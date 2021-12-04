//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

extension MainScene {
	
	class Controller: SceneController {
		
		private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Word>
		
		private let topStackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 20)
		private let searchField = SearchField()
		private let dividerView = UIView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.backgroundColor = .systemGray6
		}
		private let tableView = UITableView.default {
			$0.register(headerFooterType: SearchResultHeaderView.self)
			$0.contentInset.top -= 30
		}
		
		private var dataSource: TableViewDataSource!
		private let viewModel: ViewModel
		private var router: Router
		
		init(viewModel: ViewModel) {
			self.viewModel = viewModel
			self.router = Router()
			super.init(nibName: nil, bundle: nil)
			self.router.sourceController = self
			self.router.dataProvider = self
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func viewDidLoad() {
			super.viewDidLoad()
			setupViews()
			setupBindings()
			showLaunchView()
		}
		
		// MARK: - Setup Views
		
		private func setupViews() {
			view.backgroundColor = .systemBackground
			setupTopBar()
			setupSearchField()
			setupDividerView()
			setupTableView()
		}
		
		private func setupTopBar() {
			let appLogoView = makeAppLogoView()
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAboutScene))
			appLogoView.addGestureRecognizer(tapGesture)
			
			let databasesButton = makeTopButton(symbolName: "externaldrive") { [unowned self] in
				self.presentDatabasesScene()
			}
			let myWordsButton = makeTopButton(symbolName: "book") { [unowned self] in
				self.presentMyWordsScene()
			}
			let historyButton = makeTopButton(symbolName: "clock") { [unowned self] in
				self.presentHistoryScene()
			}
			
			topStackView.addArrangedSubviews(
				appLogoView,
				databasesButton,
				myWordsButton,
				historyButton
			)
			
			view.addSubview(topStackView) {
				$0.top.equalTo(view.safeAreaLayoutGuide)
				$0.leading.equalToSuperview().inset(16)
				$0.height.equalTo(60)
			}
		}
		
		private func setupSearchField() {
			view.addSubview(searchField) {
				$0.top.equalTo(topStackView.snp.bottom)
				$0.leading.trailing.equalToSuperview().inset(16)
				$0.height.equalTo(44)
			}
		}
		
		private func setupDividerView() {
			view.addSubview(dividerView) {
				$0.height.equalTo(1)
				$0.leading.trailing.equalToSuperview()
				$0.top.equalTo(searchField.snp.bottom).offset(16)
			}
		}
		
		private func setupTableView() {
			view.addSubview(tableView) { (maker) in
				maker.top.equalTo(dividerView.snp.bottom)
				maker.leading.trailing.bottom.equalToSuperview()
			}
			
			dataSource = TableViewDataSource(tableView: tableView) { tableView, indexPath, word in
				guard let type = SearchQueryType(intValue: indexPath.section)
				else { fatalError() }
				
				let configuration: UIContentConfiguration
				let title = word.nonEmptyTitle
				let meaning = word.text
				let database = word.database.name
				
				switch type {
				case .exact:
					configuration = SearchResultRowViewConfiguration(
						meaning: meaning,
						database: database
					)
					
				case .ava,
					 .like,
					 .text:
					configuration = SearchResultWithWordRowViewConfiguration(
						word: title,
						meaning: meaning,
						database: database
					)
				}
				
				let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
				cell.contentConfiguration = configuration
				return cell
			}
			tableView.delegate = self
		}
		
		// MARK: - Setup Bindings
		
		private func setupBindings() {
			viewModel
				.$searchStatus
				.receive(on: DispatchQueue.main)
				.dropFirst()
				.sink(receiveValue: { [weak self] (status) in
					guard let self = self else { return }
					self.configureDataSource(for: status)
				})
				.store(in: &cancellables)
			
			searchField
				.queryPublisher
				.sink { [unowned self] (text) in
					self.searchField.resignFirstResponder()
					self.viewModel.search(text: text)
				}
				.store(in: &cancellables)
		}
		
		// MARK: - Configure Data Source
		
		private func configureDataSource(for status: SearchStatus) {
			var snapshot = dataSource?.snapshot() ?? NSDiffableDataSourceSnapshot<Section, Word>()
			snapshot.deleteAllItems()
			
			switch status {
			case .notRequested:
				tableView.backgroundView = nil
				searchField.isEnabled = true
				searchField.setText("")
				searchField.becomeFirstResponder()
				
			case .searching:
				let loadingView = makeLoadingView()
				loadingView.frame = tableView.bounds
				tableView.backgroundView = loadingView
				searchField.isEnabled = false
				
			case .failed(let error):
				let errorView = makeErrorView(for: error)
				errorView.frame = tableView.bounds
				tableView.backgroundView = errorView
				searchField.isEnabled = true
				
			case .success(let results):
				tableView.backgroundView = nil
				searchField.isEnabled = true
				snapshot.appendSections([.exact, .ava, .like, .text])
				snapshot.appendItems(results.exact.results, toSection: .exact)
				snapshot.appendItems(results.ava.results, toSection: .ava)
				snapshot.appendItems(results.like.results, toSection: .like)
				snapshot.appendItems(results.text.results, toSection: .text)
			}
			
			dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
		}
		
		// MARK: - Routings
		
		private func presentDatabasesScene() {
			router.presentDatabasesScene()
		}
		
		private func presentMyWordsScene() {
			router.presentMyWordsScene()
		}
		
		private func presentHistoryScene() {
			router.presentHistoryScene()
		}
		
		@objc
		private func presentAboutScene() {
			router.presentAboutScene()
		}
		
		private func presentWordScene(for word: Word) {
			router.presentWordScene(for: word)
		}
		
		// MARK: - View Makers
		
		private func makeAppLogoView() -> UIView {
			let containerView = UIView() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.setCornerRadius(8)
				$0.backgroundColor = .label
				$0.snp.makeConstraints({ maker in maker.size.equalTo(32) })
			}
			
			let vLabel = UILabel() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.text = "و"
				$0.font = .pinar(size: 22, weight: .bold)
				$0.textAlignment = .center
				$0.textColor = .systemBackground
			}
			
			containerView.addSubview(vLabel) {
				$0.leading.trailing.equalToSuperview()
				$0.centerY.equalToSuperview().offset(-4)
			}
			
			return containerView
		}
		
		private func makeTopButton(symbolName: String, handler: @escaping () -> Void) -> UIButton {
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
			let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
			let button = UIButton() .. {
				$0.tintColor = .label
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.setImage(image, for: .normal)
				$0.snp.makeConstraints { (maker) in
					maker.size.equalTo(32)
				}
			}
			button
				.tapPublisher
				.sink(receiveValue: handler)
				.store(in: &cancellables)
			
			return button
		}
		
		private func makeLoadingView() -> UIView {
			let containerView = UIView()
			
			let activityIndicatorView = UIActivityIndicatorView(style: .medium) .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.color = .label
				$0.startAnimating()
			}
			let label = UILabel() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.text = "در حال جستجو..."
				$0.font = .pinar(size: 18, weight: .medium)
				$0.textAlignment = .right
				$0.textColor = .label
			}
			
			let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 12) .. {
				$0.addArrangedSubviews(activityIndicatorView, label)
			}
			
			containerView.addSubview(stackView) { (maker) in
				maker.leading.trailing.top.equalToSuperview().inset(16)
			}
			
			
			return containerView
		}
		
		private func makeErrorView(for error: Error) -> UIView {
			let containerView = UIView()
			
			let titleLabel = UILabel() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.text = "بروز خطا"
				$0.font = .pinar(size: 18, weight: .semibold)
				$0.textAlignment = .right
				$0.textColor = .systemRed
			}
			let messageLabel = UILabel() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.text = "مجدد تلاش کنین"
				$0.font = .pinar(size: 16, weight: .regular)
				$0.textAlignment = .right
				$0.textColor = .label
			}
			
			
			let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 12) .. {
				$0.addArrangedSubviews(titleLabel, messageLabel)
			}
			
			containerView.addSubview(stackView) { (maker) in
				maker.leading.trailing.top.equalToSuperview().inset(16)
			}
			
			
			return containerView
		}
		
		// MARK: - Launch Animation
		
		private func showLaunchView() {
			let containerView = UIView() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.backgroundColor = .systemBackground
			}
			
			let squareView = UIView() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.backgroundColor = .label
				$0.setCornerRadius(40)
				$0.alpha = 0
			}
			let vLabel = UILabel() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.textAlignment = .center
				$0.font = .pinar(size: 100, weight: .bold)
				$0.text = "و"
				$0.textColor = .systemBackground
				$0.alpha = 0
			}
			
			containerView.addSubview(squareView) { (maker) in
				maker.size.equalTo(180)
				maker.center.equalToSuperview()
			}
			containerView.addSubview(vLabel) { (maker) in
				maker.center.equalToSuperview()
			}
			
			view.addSubview(containerView) { (maker) in
				maker.edges.equalToSuperview()
			}
			
			squareView.transform = .init(scaleX: 1.1, y: 1.1)
			let originalTransform = CGAffineTransform.identity.translatedBy(x: 0, y: -16)
			vLabel.transform = originalTransform.scaledBy(x: 0.8, y: 0.8)
			
			UIView.animate(withDuration: 0.6, delay: 0.2, options: [.curveEaseOut]) {
				squareView.alpha = 1
				squareView.transform = .identity
				vLabel.alpha = 1
				vLabel.transform = originalTransform
			} completion: { (_) in
				UIView.animate(withDuration: 0.5, delay: 0.3, options: []) {
					containerView.alpha = 0
				} completion: { (_) in
					self.searchField.becomeFirstResponder()
					containerView.removeFromSuperview()
				}
			}
		}
		
	}
	
}

extension MainScene.Controller {
	
	enum Section {
		case exact, ava, like, text
	}
	
}

// MARK: - UITableViewDelegate

extension MainScene.Controller: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let type = SearchQueryType(intValue: section) else { return nil }
		let headerView = tableView.dequeueReusableHeaderFooterView(SearchResultHeaderView.self)
		headerView.configure(text: type.persian)
		return headerView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 64
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return .leastNonzeroMagnitude
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		defer {
			tableView.deselectRow(at: indexPath, animated: true)
		}
		
		guard case .success(let result) = viewModel.searchStatus,
			  let type = SearchQueryType(intValue: indexPath.section)
		else { return }
		
		let index = indexPath.row
		let word: Word
		switch type {
		case .exact	: word = result.exact.results[index]
		case .ava	: word = result.ava.results[index]
		case .like	: word = result.like.results[index]
		case .text	: word = result.text.results[index]
		}
		
		presentWordScene(for: word)
	}
	
}

extension MainScene.Controller: MainSceneRouterDataProvider {
	
	func historySceneDelegate() -> HistorySceneDelegate {
		return self
	}
	
}

extension MainScene.Controller: HistorySceneDelegate {
	
	func historyScene(startSearchFor query: Query) {
		searchField.setText(query.query)
		viewModel.search(text: query.query)
	}
	
}

//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

extension MainScene {
	
	class Controller: SceneController {
		
		private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Word>
		
		private let topStackView = UIStackView(.horizontal, alignment: .center, spacing: 20)
		private let searchField = SearchField()
		private let dividerView = UIView()
		private let tableView = UITableView.default()
		
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
			
			let databasesButton = makeTopButton(symbolName: .UIImageSystemName.database) { [unowned self] in
				self.presentDatabasesScene()
			}
			let myWordsButton = makeTopButton(symbolName: .UIImageSystemName.bookmark) { [unowned self] in
				self.presentMyWordsScene()
			}
			let historyButton = makeTopButton(symbolName: .UIImageSystemName.history) { [unowned self] in
				self.presentHistoryScene()
			}
			
			topStackView.addArrangedSubview(appLogoView)
			topStackView.addArrangedSubview(databasesButton)
			topStackView.addArrangedSubview(myWordsButton)
			topStackView.addArrangedSubview(historyButton)
			
			view.addSubview(topStackView)
			topStackView.snp.makeConstraints {
				$0.top.equalTo(view.safeAreaLayoutGuide)
				$0.leading.equalToSuperview().inset(16)
				$0.height.equalTo(60)
			}
		}
		
		private func setupSearchField() {
			searchField.inputAccessoryView = InputAccessorView(responder: searchField)
			view.addSubview(searchField)
			searchField.snp.makeConstraints {
				$0.top.equalTo(topStackView.snp.bottom)
				$0.leading.trailing.equalToSuperview().inset(16)
				$0.height.equalTo(44)
			}
		}
		
		private func setupDividerView() {
			dividerView.backgroundColor = .systemGray6
			
			view.addSubview(dividerView)
			dividerView.snp.makeConstraints {
				$0.height.equalTo(1)
				$0.leading.trailing.equalToSuperview()
				$0.top.equalTo(searchField.snp.bottom).offset(16)
			}
		}
		
		private func setupTableView() {
			tableView.register(headerFooterType: SearchResultHeaderView.self)
			
			view.addSubview(tableView)
			tableView.snp.makeConstraints { (maker) in
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
						word: nil,
						meaning: meaning,
						database: database
					)
					
				case .ava,
					 .like,
					 .text:
					configuration = SearchResultRowViewConfiguration(
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
			setupViewModelBindings()
			setupViewsBindings()
			setupOtherBindings()
		}
		
		private func setupViewModelBindings() {
			viewModel
				.$searchStatus
				.receive(on: DispatchQueue.main)
				.dropFirst()
				.sink { [weak self] (status) in
					guard let self = self else { return }
					self.configureDataSource(for: status)
				}
				.store(in: &cancellables)
		}
		
		private func setupViewsBindings() {
			searchField
				.queryPublisher
				.sink { [unowned self] (text) in
					self.searchField.resignFirstResponder()
					self.viewModel.search(text: text)
				}
				.store(in: &cancellables)
			
			searchField
				.fieldDidClearPubisher
				.sink { [unowned self] in
					self.viewModel.cancelSearch()
				}
				.store(in: &cancellables)
		}
		
		private func setupOtherBindings() {
			NotificationCenter
				.default
				.publisher(for: UIApplication.didEnterBackgroundNotification)
				.sink { [weak self] _ in
					guard let self = self else { return }
					self.searchField.resignFirstResponder()
				}
				.store(in: &cancellables)
			
			NotificationCenter
				.default
				.publisher(for: UIApplication.willEnterForegroundNotification)
				.delay(for: 0.6, scheduler: DispatchQueue.main)
				.sink { [weak self] _ in
					guard let self = self else { return }
					
					let isSearchFieldEmpty = (self.searchField.text ?? "").isEmpty
					let isAnyScenePresented = self.presentedViewController != nil
					let isAnyScenePushed = (self.navigationController?.viewControllers.count ?? 0) > 1
					
					if isSearchFieldEmpty, !isAnyScenePresented, !isAnyScenePushed {
						self.searchField.becomeFirstResponder()
					}
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
			let containerView = UIView()
			containerView.translatesAutoresizingMaskIntoConstraints = false
			containerView.setCornerRadius(8)
			containerView.backgroundColor = .label
			containerView.snp.makeConstraints({ maker in maker.size.equalTo(32) })
			
			let vLabel = UILabel()
			vLabel.text = R.string.mainScene.v()
			vLabel.font = .appFont(size: 22, weight: .bold)
			vLabel.textAlignment = .center
			vLabel.textColor = .systemBackground
			
			containerView.addSubview(vLabel)
			vLabel.snp.makeConstraints {
				$0.leading.trailing.equalToSuperview()
				$0.centerY.equalToSuperview().offset(-4)
			}
			
			return containerView
		}
		
		private func makeTopButton(symbolName: String, handler: @escaping () -> Void) -> UIButton {
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
			let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
			let button = UIButton()
			button.tintColor = .label
			button.setImage(image, for: .normal)
			button.snp.makeConstraints { (maker) in
				maker.size.equalTo(32)
			}
			button
				.tapPublisher
				.sink(receiveValue: handler)
				.store(in: &cancellables)
			
			return button
		}
		
		private func makeLoadingView() -> UIView {
			let activityIndicatorView = UIActivityIndicatorView(style: .medium)
			activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
			activityIndicatorView.color = .label
			activityIndicatorView.startAnimating()
			
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = R.string.mainScene.loadingText()
			label.font = .appFont(size: 18, weight: .medium)
			label.textAlignment = .right
			label.textColor = .label
			
			let stackView = UIStackView(.horizontal, alignment: .center, spacing: 12)
			stackView.addArrangedSubview(activityIndicatorView)
			stackView.addArrangedSubview(label)
			
			let containerView = UIView()
			containerView.addSubview(stackView)
			stackView.snp.makeConstraints { (maker) in
				maker.leading.trailing.top.equalToSuperview().inset(16)
			}
			
			return containerView
		}
		
		private func makeErrorView(for error: Error) -> UIView {
			let titleLabel = UILabel()
			titleLabel.translatesAutoresizingMaskIntoConstraints = false
			titleLabel.text = R.string.mainScene.errorTitle()
			titleLabel.font = .appFont(size: 18, weight: .semibold)
			titleLabel.textAlignment = .right
			titleLabel.textColor = .systemRed
			
			let messageLabel = UILabel()
			messageLabel.translatesAutoresizingMaskIntoConstraints = false
			messageLabel.text = R.string.mainScene.tryAgainTitle()
			messageLabel.font = .appFont(size: 16, weight: .regular)
			messageLabel.textAlignment = .right
			messageLabel.textColor = .label
			
			let stackView = UIStackView(.vertical, spacing: 12)
			stackView.addArrangedSubview(titleLabel)
			stackView.addArrangedSubview(messageLabel)
			
			let containerView = UIView()
			containerView.addSubview(stackView)
			stackView.snp.makeConstraints { (maker) in
				maker.leading.trailing.top.equalToSuperview().inset(16)
			}
			
			return containerView
		}
		
		// MARK: - Launch Animation
		
		private func showLaunchView() {
			let containerView = UIView()
			containerView.backgroundColor = .systemBackground
			
			let squareView = UIView()
			squareView.backgroundColor = .label
			squareView.setCornerRadius(40)
			squareView.alpha = 0
			
			let vLabel = UILabel()
			vLabel.textAlignment = .center
			vLabel.font = .appFont(size: 100, weight: .bold)
			vLabel.text = R.string.mainScene.v()
			vLabel.textColor = .systemBackground
			vLabel.alpha = 0
			
			containerView.addSubview(squareView)
			squareView.snp.makeConstraints { (maker) in
				maker.size.equalTo(180)
				maker.center.equalToSuperview()
			}
			
			containerView.addSubview(vLabel)
			vLabel.snp.makeConstraints { (maker) in
				maker.center.equalToSuperview()
			}
			
			view.addSubview(containerView)
			containerView.snp.makeConstraints { (maker) in
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
		
		guard
			case .success(let result) = viewModel.searchStatus,
			let type = SearchQueryType(intValue: indexPath.section)
		else { return }
		
		let index = indexPath.row
		let word: Word
		switch type {
		case .exact:
			word = result.exact.results[index]
		case .ava:
			word = result.ava.results[index]
		case .like:
			word = result.like.results[index]
		case .text:
			word = result.text.results[index]
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

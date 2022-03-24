import UIKit
import VazheganFramework
import Combine
import CombineCocoa
import MobileCoreServices

@objc(MainController)
final class MainController: UIViewController {
	
	private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Word>
	
	deinit {
		viewModel.cancelSearch()
		extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
	}
	
	private let dismissButton = UIButton() .. {
		let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
		let image = UIImage(systemName: "xmark", withConfiguration: symbolConfiguration)
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.tintColor = .systemGray
		$0.setImage(image, for: .normal)
		$0.snp.makeConstraints { (maker) in
			maker.size.equalTo(32)
		}
	}
	private let tableView = UITableView.default {
		$0.register(headerFooterType: SearchResultHeaderView.self)
		$0.allowsSelection = false
		$0.contentInset.top += 30
	}
	
	private var viewModel: ViewModel!
	private var cancellables = Set<AnyCancellable>()
	private var dataSource: TableViewDataSource!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepare()
		setupViews()
		setupBindings()
		getInputTextFromContext()
	}
	
	private func prepare() {
		let searchManager = DefaultSearchManager(
			networkManager: MoyaNetworkManager.default,
			databaseManager: RealmManager.default,
			queryManager: RealmManager.default
		)
		viewModel = ViewModel(searchManager: searchManager)
	}
	
	private func setupViews() {
		view.backgroundColor = .systemBackground
		view.addSubview(tableView) { (maker) in
			maker.edges.equalToSuperview()
		}
		
		view.addSubview(dismissButton) { maker in
			maker.top.equalTo(view.safeAreaLayoutGuide).inset(20)
			maker.trailing.equalToSuperview().inset(20)
		}
		view.bringSubviewToFront(dismissButton)
		
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
	
	private func setupBindings() {
		dismissButton
			.tapPublisher
			.sink { [unowned self] (_) in
				self.dismiss()
			}
			.store(in: &cancellables)
		
		viewModel
			.$searchStatus
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] (status) in
				guard let self = self else { return }
				
				var snapshot = NSDiffableDataSourceSnapshot<Section, Word>()
				
				switch status {
				case .notRequested:
					break
				case .searching:
					break
					
				case .failed(let error):
					self.setupErrorLabel(with: error.localizedDescription)
					
				case .success(let results):
					snapshot.appendSections([.exact, .ava, .like, .text])
					snapshot.appendItems(results.exact.results, toSection: .exact)
					snapshot.appendItems(results.ava.results, toSection: .ava)
					snapshot.appendItems(results.like.results, toSection: .like)
					snapshot.appendItems(results.text.results, toSection: .text)
				}
				
				self.dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
			})
			.store(in: &cancellables)
	}
	
	private func dismiss() {
		extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
		dismiss(animated: true, completion: nil)
	}
	
	enum Section {
		case exact, ava, like, text
	}
	
}

extension MainController: UITableViewDelegate {
	
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
	
}

extension MainController {
	
	private func getInputTextFromContext() {
		let typeIdentifier = kUTTypeText as String
		guard
			let inputItems = extensionContext?.inputItems, !inputItems.isEmpty,
			let textItem = inputItems[0] as? NSExtensionItem,
			let textItemProvider = textItem.attachments?.first,
			textItemProvider.hasItemConformingToTypeIdentifier(typeIdentifier)
		else {
			dismiss()
			return
		}
		
		textItemProvider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self] (item, error) in
			DispatchQueue.main.async { [weak self] in
				self?.handleContextProviderResult(item: item, error: error)
			}
		}
		
	}
	
	private func handleContextProviderResult(item: NSSecureCoding?, error: Error?) {
		guard error == nil else {
			setupErrorLabel(with: error!.localizedDescription)
			return
		}
		
		guard let string = item as? String else {
			setupErrorLabel(with: "متن در دسترس نمی‌باشد")
			return
		}
		
		viewModel.search(text: string)
	}
	
	private func setupErrorLabel(with message: String) {
		let label = UILabel(frame: tableView.bounds)
		label.font = .pinar(size: 16)
		label.textColor = .systemRed
		label.text = "بروز خطا" + "\n\n" + message
		label.textAlignment = .center
		tableView.backgroundView = label
	}
	
}

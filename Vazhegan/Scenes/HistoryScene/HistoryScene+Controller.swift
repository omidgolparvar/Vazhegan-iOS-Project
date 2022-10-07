//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

protocol HistorySceneDelegate: AnyObject {
	func historyScene(startSearchFor query: Query)
}

extension HistoryScene {
	
	final class Controller: SceneController {
		
		private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Query>
		
		private let sceneBar = SceneTitleBar()
		private let tableView = UITableView.default()
		
		private let viewModel: ViewModel
		private var router: Router
		private weak var delegate: HistorySceneDelegate?
		private var dataSource: TableViewDataSource!
		
		init(viewModel: ViewModel, delegate: HistorySceneDelegate) {
			self.viewModel = viewModel
			self.router = Router()
			self.delegate = delegate
			super.init(nibName: nil, bundle: nil)
			self.router.sourceController = self
			self.router.dataProvider = nil
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func viewDidLoad() {
			super.viewDidLoad()
			setupViews()
			setupBindings()
		}
		
		// MARK: - Setup Views
		
		private func setupViews() {
			title = R.string.historyScene.pageTitle()
			view.backgroundColor = .systemBackground
			sceneBar.added(to: self)
			setupTableView()
		}
		
		private func setupTableView() {
			tableView.contentInset.top -= 15
			view.addSubview(tableView)
			tableView.snp.makeConstraints { (maker) in
				maker.top.equalTo(sceneBar.snp.bottom)
				maker.leading.trailing.bottom.equalToSuperview()
			}
			
			dataSource = TableViewDataSource(tableView: tableView) { tableView, indexPath, query in
				let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
				cell.contentConfiguration = QueryRowViewConfiguration(
					query: query.query,
					deleteHandler: { [unowned self] in
						self.viewModel.removeQuery(query)
					}
				)
				return cell
			}
			tableView.delegate = self
		}
		
		private func setupBackgroundView(isInEmptyState: Bool) {
			if isInEmptyState {
				let messageData = BackgroundMessageView.MessageData(
					emoji: "👀",
					title: R.string.historyScene.emptyStateTitle(),
					text: R.string.historyScene.emptyStateText()
				)
				tableView.backgroundView = BackgroundMessageView(frame: tableView.bounds, data: messageData)
			} else {
				tableView.backgroundView = nil
			}
		}
		
		// MARK: - Setup Bindings
		
		private func setupBindings() {
			viewModel
				.$queries
				.sink { [weak self] queries in
					guard let self = self else { return }
					
					self.setupBackgroundView(isInEmptyState: queries.isEmpty)
					
					var snapshot = NSDiffableDataSourceSnapshot<Section, Query>()
					snapshot.appendSections([.main])
					snapshot.appendItems(queries, toSection: .main)
					
					self.dataSource.apply(snapshot)
				}
				.store(in: &cancellables)
		}
		
	}
	
}

extension HistoryScene.Controller {
	
	enum Section: Int {
		case main
	}
	
}

// MARK: - UITableViewDelegate

extension HistoryScene.Controller: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let query = dataSource.itemIdentifier(for: indexPath) else { return }
		dismiss(animated: true) { [delegate] in
			delegate?.historyScene(startSearchFor: query)
		}
	}
	
}

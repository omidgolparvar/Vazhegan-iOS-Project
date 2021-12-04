//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

extension DatabasesScene {
	
	final class Controller: SceneController {
		
		private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Database>
		
		private let sceneBar = SceneTitleBar()
		private let tableView = UITableView.default {
			$0.contentInset.top -= 15
		}
		
		private let viewModel: ViewModel
		private var router: Router
		private var dataSource: TableViewDataSource!
		
		init(viewModel: ViewModel) {
			self.viewModel = viewModel
			self.router = Router()
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
			title = "پایگاه‌های مورد استفاده"
			view.backgroundColor = .systemBackground
			sceneBar.added(to: self)
			setupTableView()
		}
		
		private func setupTableView() {
			view.addSubview(tableView) { (maker) in
				maker.top.equalTo(sceneBar.snp.bottom)
				maker.leading.trailing.bottom.equalToSuperview()
			}
			
			dataSource = TableViewDataSource(tableView: tableView) { tableView, indexPath, database in
				let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
				cell.contentConfiguration = DatabaseRowViewConfiguration(
					databaseName: database.name,
					isEnabled: database.isEnabled
				)
				return cell
			}
			tableView.delegate = self
		}
		
		// MARK: - Setup Bindings
		
		private func setupBindings() {
			viewModel
				.$databases
				.sink { [weak self] databases in
					guard let self = self else { return }
					
					var snapshot = NSDiffableDataSourceSnapshot<Section, Database>()
					snapshot.appendSections([.main])
					snapshot.appendItems(databases, toSection: .main)
					self.dataSource.apply(snapshot)
				}
				.store(in: &cancellables)
		}
		
	}
	
}

extension DatabasesScene.Controller {
	
	enum Section: Int {
		case main
	}
	
}

// MARK: - UITableViewDelegate

extension DatabasesScene.Controller: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let database = dataSource.itemIdentifier(for: indexPath) else { return }
		viewModel.setEnabled(!database.isEnabled, for: database)
		tableView.deselectRow(at: indexPath, animated: true)
		var snapshot = dataSource.snapshot()
		snapshot.reloadItems([viewModel.databases[indexPath.row]])
		dataSource.apply(snapshot)
	}
	
}

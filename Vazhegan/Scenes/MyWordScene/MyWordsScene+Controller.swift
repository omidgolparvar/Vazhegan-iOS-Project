//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

extension MyWordsScene {
	
	final class Controller: SceneController {
		
		private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Word>
		
		private let sceneBar = SceneTitleBar()
		private let tableView = UITableView.default()
		private let sortButton = UIButton()
		
		private var isFirstAppear = true
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
		
		override func viewDidAppear(_ animated: Bool) {
			super.viewDidAppear(animated)
			isFirstAppear = false
		}
		
		// MARK: - Setup Views
		
		private func setupViews() {
			title = R.string.myWordsScene.pageTitle()
			view.backgroundColor = .systemBackground
			sceneBar.added(to: self)
			setupTableView()
			setupSortButton()
		}
		
		private func setupTableView() {
			tableView.contentInset.top -= 15
			
			view.addSubview(tableView)
			tableView.snp.makeConstraints { (maker) in
				maker.top.equalTo(sceneBar.snp.bottom)
				maker.leading.trailing.bottom.equalToSuperview()
			}
			
			dataSource = TableViewDataSource(tableView: tableView) { tableView, indexPath, word in
				let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
				cell.contentConfiguration = SearchResultRowViewConfiguration(
					word: word.nonEmptyTitle,
					meaning: word.text,
					database: word.database.name
				)
				return cell
			}
			tableView.delegate = self
		}
		
		private func setupBackgroundView(isInEmptyState: Bool) {
			if isInEmptyState {
				let messageData = BackgroundMessageView.MessageData(
					emoji: "👀",
					title: R.string.myWordsScene.emptyStateTitle(),
					text: R.string.myWordsScene.emptyStateText()
				)
				tableView.backgroundView = BackgroundMessageView(frame: tableView.bounds, data: messageData)
			} else {
				tableView.backgroundView = nil
			}
		}
		
		private func setupSortButton() {
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
			let image = UIImage(systemName: .UIImageSystemName.sort, withConfiguration: symbolConfiguration)
			sortButton.translatesAutoresizingMaskIntoConstraints = false
			sortButton.showsMenuAsPrimaryAction = true
			sortButton.tintColor = .label
			sortButton.setImage(image, for: .normal)
			sortButton.snp.makeConstraints { (maker) in
				maker.size.equalTo(32)
			}
			
			sceneBar.addButton(sortButton)
		}
		
		private func configureSortButtonMenu() {
			let option = viewModel.sortOption
			
			let sortByTitleAction = UIAction(title: ViewModel.SortOption.title.name, image: UIImage()) { [unowned self] _ in
				self.viewModel.sortOption = .title
			}
			sortByTitleAction.state = option == .title ? .on : .off
			
			let sortByDateAction = UIAction(title: ViewModel.SortOption.date.name, image: UIImage()) { [unowned self] _ in
				self.viewModel.sortOption = .date
			}
			sortByDateAction.state = option == .date ? .on : .off
			
			sortButton.menu = UIMenu(title: R.string.myWordsScene.sortOptionMenuTitle(), children: [sortByDateAction, sortByTitleAction])
		}

		
		// MARK: - Setup Bindings
		
		private func setupBindings() {
			viewModel
				.$myWords
				.sink { [weak self] words in
					guard let self = self else { return }
					
					var snapshot = NSDiffableDataSourceSnapshot<Section, Word>()
					snapshot.appendSections([.main])
					snapshot.appendItems(words, toSection: .main)
					
					self.dataSource.apply(snapshot, animatingDifferences: false) {
						self.configureSortButtonMenu()
					}
					
					if !self.isFirstAppear, !words.isEmpty {
						let indexPath = IndexPath(row: 0, section: 0)
						self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
					}
				}
				.store(in: &cancellables)
			
			viewModel
				.$myWords
				.map(\.isEmpty)
				.sink { [unowned self] in
					self.setupBackgroundView(isInEmptyState: $0)
				}
				.store(in: &cancellables)
			
			viewModel
				.$myWords
				.map(\.count)
				.map { $0 > 1 }
				.assign(to: \.isEnabled, on: sortButton)
				.store(in: &cancellables)
		}
		
	}
	
}

extension MyWordsScene.Controller {
	
	enum Section: Int {
		case main
	}
	
}

// MARK: - UITableViewDelegate

extension MyWordsScene.Controller: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		defer {
			tableView.deselectRow(at: indexPath, animated: true)
		}
		
		guard let word = dataSource.itemIdentifier(for: indexPath) else { return }
		router.presentWordScene(for: word)
	}
	
}

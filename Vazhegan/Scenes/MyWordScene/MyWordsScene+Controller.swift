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
		private let tableView = UITableView.default {
			$0.contentInset.top -= 15
		}
		
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
			title = "کلمات من"
			view.backgroundColor = .systemBackground
			sceneBar.added(to: self)
			setupTableView()
		}
		
		private func setupTableView() {
			view.addSubview(tableView) { (maker) in
				maker.top.equalTo(sceneBar.snp.bottom)
				maker.leading.trailing.bottom.equalToSuperview()
			}
			
			dataSource = TableViewDataSource(tableView: tableView) { tableView, indexPath, word in
				let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
				cell.contentConfiguration = SearchResultWithWordRowViewConfiguration(
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
					title: "خالی می‌باشه",
					text: "هیچ کلمه‌ای رو ذخیره نکردی"
				)
				UIView.transition(with: tableView, duration: 0.2, options: [.transitionCrossDissolve]) { [self] in
					tableView.backgroundView = BackgroundMessageView(frame: tableView.bounds, data: messageData)
				} completion: { (_) in }
			} else {
				tableView.backgroundView = nil
			}
		}
		
		// MARK: - Setup Bindings
		
		private func setupBindings() {
			viewModel
				.$myWords
				.sink { [weak self] words in
					guard let self = self else { return }
					
					self.setupBackgroundView(isInEmptyState: words.isEmpty)
					
					var snapshot = NSDiffableDataSourceSnapshot<Section, Word>()
					snapshot.appendSections([.main])
					snapshot.appendItems(words, toSection: .main)
					self.dataSource.apply(snapshot, animatingDifferences: !self.isFirstAppear, completion: nil)
				}
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

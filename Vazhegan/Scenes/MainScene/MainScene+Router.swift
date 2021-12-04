//

import UIKit
import VazheganFramework

protocol MainSceneRouterDataProvider: AnyObject {
	func historySceneDelegate() -> HistorySceneDelegate
}

extension MainScene {
	
	final class Router: SceneRouter {
		weak var sourceController: UIViewController?
		weak var dataProvider: MainSceneRouterDataProvider?
		
		func presentHistoryScene() {
			guard let historySceneDelegate = dataProvider?.historySceneDelegate() else { return }
			let preparationModel = HistoryScene.PreparationModel(delegate: historySceneDelegate)
			let controller = HistoryScene.initialize(with: preparationModel)
			sourceController?.present(controller, animated: true, completion: nil)
		}
		
		func presentWordScene(for word: Word) {
			let preparationModel = WordScene.PreparationModel(word: word)
			let controller = WordScene.initialize(with: preparationModel)
			sourceController?.present(controller, animated: true, completion: nil)
		}
		
		func presentMyWordsScene() {
			let controller = MyWordsScene.initialize()
			sourceController?.present(controller, animated: true, completion: nil)
		}
		
		func presentDatabasesScene() {
			let controller = DatabasesScene.initialize()
			sourceController?.present(controller, animated: true, completion: nil)
		}
		
		func presentAboutScene() {
			let controller = AboutScene.initialize()
			sourceController?.present(controller, animated: true, completion: nil)
		}
	}
	
}

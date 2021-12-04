//

import UIKit
import VazheganFramework

extension MyWordsScene {
	
	final class Router: SceneRouter {
		weak var sourceController: UIViewController?
		var dataProvider: Void? = nil
		
		func presentWordScene(for word: Word) {
			let preparationModel = WordScene.PreparationModel(word: word)
			let controller = WordScene.initialize(with: preparationModel)
			sourceController?.present(controller, animated: true, completion: nil)
		}
	}
	
}

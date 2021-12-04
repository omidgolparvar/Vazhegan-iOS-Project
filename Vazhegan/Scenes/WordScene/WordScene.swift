//

import Foundation
import UIKit
import VazheganFramework

enum WordScene: SceneProtocol {
	typealias ViewModelType = ViewModel
	typealias RouterType = Router
	typealias ViewControllerType = Controller
	typealias PreparationModel = WordScenePreparationModel
	
	class WordScenePreparationModel {
		let word: Word
		
		init(word: Word) {
			self.word = word
		}
	}
	
	static func initialize(with model: PreparationModel) -> Controller {
		let viewModel = ViewModel(
			word: model.word,
			networkManager: MoyaNetworkManager.default,
			wordManager: RealmManager.default
		)
		return Controller(viewModel: viewModel)
	}
	
}

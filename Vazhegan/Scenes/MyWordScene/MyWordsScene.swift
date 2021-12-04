//

import Foundation
import UIKit
import VazheganFramework

enum MyWordsScene: SceneProtocol {
	typealias ViewModelType = ViewModel
	typealias RouterType = Router
	typealias ViewControllerType = Controller
	typealias PreparationModel = Void
	
	static func initialize(with model: PreparationModel) -> Controller {
		let viewModel = ViewModel(wordManager: RealmManager.default)
		return Controller(viewModel: viewModel)
	}
}

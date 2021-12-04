//

import Foundation
import UIKit
import VazheganFramework

enum HistoryScene: SceneProtocol {
	typealias ViewModelType = ViewModel
	typealias RouterType = Router
	typealias ViewControllerType = Controller
	typealias PreparationModel = HistoryScenePreparationModel
	
	class HistoryScenePreparationModel {
		let delegate: HistorySceneDelegate
		
		init(delegate: HistorySceneDelegate) {
			self.delegate = delegate
		}
	}
	
	static func initialize(with model: PreparationModel) -> Controller {
		let viewModel = ViewModel(queryManager: RealmManager.default)
		return Controller(viewModel: viewModel, delegate: model.delegate)
	}
	
}

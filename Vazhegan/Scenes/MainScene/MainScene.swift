//

import Foundation
import UIKit
import VazheganFramework

enum MainScene: SceneProtocol {
	typealias ViewModelType = ViewModel
	typealias RouterType = Router
	typealias ViewControllerType = Controller
	typealias PreparationModel = Void
	
	static func initialize(with model: Void) -> Controller {
		let searchManager = DefaultSearchManager(
			networkManager: MoyaNetworkManager.default,
			databaseManager: RealmManager.default,
			queryManager: RealmManager.default
		)
		let viewModel = ViewModel(searchManager: searchManager)
		return Controller(viewModel: viewModel)
	}
	
}

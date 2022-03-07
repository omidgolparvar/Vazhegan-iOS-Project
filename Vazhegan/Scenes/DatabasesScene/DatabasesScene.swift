//

import Foundation
import UIKit
import VazheganFramework

enum DatabasesScene: SceneProtocol {
	typealias ViewControllerType = Controller
	typealias PreparationModel = Void
	
	static func initialize(with model: PreparationModel) -> Controller {
		let viewModel = ViewModel(databaseManager: RealmManager.default)
		return Controller(viewModel: viewModel)
	}
}

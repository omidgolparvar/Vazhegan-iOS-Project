//

import Foundation
import UIKit
import VazheganFramework

enum AboutScene: SceneProtocol {
	typealias ViewModelType = ViewModel
	typealias RouterType = Router
	typealias ViewControllerType = Controller
	typealias PreparationModel = Void
	
	static func initialize(with model: PreparationModel) -> Controller {
		let viewModel = ViewModel()
		return Controller(viewModel: viewModel)
	}
}

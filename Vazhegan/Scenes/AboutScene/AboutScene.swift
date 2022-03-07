//

import Foundation
import UIKit
import VazheganFramework

enum AboutScene: SceneProtocol {
	typealias ViewControllerType = Controller
	typealias PreparationModel = Void
	
	static func initialize(with model: PreparationModel) -> Controller {
		let viewModel = ViewModel()
		return Controller(viewModel: viewModel)
	}
}

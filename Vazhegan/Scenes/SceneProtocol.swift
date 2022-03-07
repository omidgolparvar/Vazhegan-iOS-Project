//

import Foundation
import UIKit

// MARK: - Scene Protocol

protocol SceneProtocol {
	associatedtype ViewControllerType: SceneController
	associatedtype PreparationModel
	
	static func initialize(with model: PreparationModel) -> ViewControllerType
}

extension SceneProtocol where PreparationModel == Void {
	static func initialize() -> ViewControllerType {
		initialize(with: ())
	}
}

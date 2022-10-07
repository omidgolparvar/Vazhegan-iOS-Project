//

import UIKit
import SnapKit

extension UIView {
	
	func setCornerRadius(_ cornerRadius: CGFloat, cornerCurve: CALayerCornerCurve = .continuous) {
		layer.cornerRadius = cornerRadius
		layer.cornerCurve = cornerCurve
	}
	
}


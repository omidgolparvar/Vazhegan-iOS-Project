//

import UIKit
import SnapKit

extension UIView {
	
	func addSubview(_ view: UIView, with constraintConfigurator: (ConstraintMaker) -> Void) {
		addSubview(view)
		view.snp.makeConstraints(constraintConfigurator)
	}
	
	func setCornerRadius(_ cornerRadius: CGFloat, cornerCurve: CALayerCornerCurve = .continuous) {
		layer.cornerRadius = cornerRadius
		layer.cornerCurve = cornerCurve
	}
	
}


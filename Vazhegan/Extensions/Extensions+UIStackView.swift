//

import UIKit

extension UIStackView {
	
	convenience init(
		axis: NSLayoutConstraint.Axis,
		alignment: Alignment,
		distribution: Distribution,
		spacing: CGFloat
	) {
		self.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.axis = axis
		self.alignment = alignment
		self.distribution = distribution
		self.spacing = spacing
	}
	
	func addArrangedSubviews(_ views: UIView...) {
		views.forEach(addArrangedSubview(_:))
	}
	
}

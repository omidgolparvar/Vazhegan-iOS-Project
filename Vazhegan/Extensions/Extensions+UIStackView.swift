//

import UIKit

extension UIStackView {
	
	convenience init(
		_ axis: NSLayoutConstraint.Axis,
		alignment: Alignment = .fill,
		distribution: Distribution = .fill,
		spacing: CGFloat = 8
	) {
		self.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.axis = axis
		self.alignment = alignment
		self.distribution = distribution
		self.spacing = spacing
	}
	
}

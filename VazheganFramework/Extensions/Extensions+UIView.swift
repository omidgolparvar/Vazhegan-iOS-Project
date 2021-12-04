import Foundation

public extension UIView {
	
	func setCornerRadius(_ cornerRadius: CGFloat, cornerCurve: CALayerCornerCurve = .continuous) {
		layer.cornerRadius = cornerRadius
		layer.cornerCurve = cornerCurve
		clipsToBounds = true
	}
	
	func roundCorners() {
		setCornerRadius(min(frame.width, frame.height) / 2.0, cornerCurve: .circular)
	}
	
}

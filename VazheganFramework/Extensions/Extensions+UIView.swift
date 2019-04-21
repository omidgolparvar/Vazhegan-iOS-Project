//
//  Extensions+UIView.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

public extension UIView {
	
	public func shake() {
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.duration = 0.6
		animation.values = [-16.0, 16.0, -16.0, 16.0, -8.0, 8.0, -5.0, 5.0, 0.0]
		self.layer.add(animation, forKey: "shake")
	}
	
	public func setCornerRadius(_ cornerRadius: CGFloat) {
		self.layer.cornerRadius = cornerRadius
		self.clipsToBounds = true
	}
	
	public func roundCorners() {
		self.setCornerRadius(self.frame.height / 2.0)
	}
	
	public func setRadiusForCorners(radius: CGFloat, corners: UIRectCorner) {
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
	
	public func setBorder(color: UIColor?, width: CGFloat) {
		self.layer.borderColor = color?.cgColor
		self.layer.borderWidth = width
	}
	
}

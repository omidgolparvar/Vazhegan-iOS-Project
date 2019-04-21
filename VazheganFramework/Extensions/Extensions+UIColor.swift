//
//  Extensions+UIColor.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

extension UIColor {
	
	public static func Initialize(hexCode: String) -> UIColor {
		var colorCode: String = hexCode
		
		if (colorCode.hasPrefix("#")) {
			let startIndex = colorCode.index(colorCode.startIndex, offsetBy: 1)
			colorCode = String(colorCode[startIndex...])
		}
		
		var rgbValue: UInt32 = 0
		Scanner(string: colorCode).scanHexInt32(&rgbValue)
		
		return UIColor.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	public static var V: UIColor {
		return UIColor.Initialize(hexCode: "#4527A0")
	}
	
}

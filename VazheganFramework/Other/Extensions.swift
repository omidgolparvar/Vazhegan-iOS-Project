//
//  Extensions.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation

extension UIColor {
	
	public convenience init(hexCode: String) {
		var colorCode: String = hexCode
		
		if (colorCode.hasPrefix("#")) {
			let startIndex = colorCode.index(colorCode.startIndex, offsetBy: 1)
			colorCode = String(colorCode[startIndex...])
		}
		
		var rgbValue: UInt32 = 0
		Scanner(string: colorCode).scanHexInt32(&rgbValue)
		
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
}

extension String {
	
	public var trimmed: String {
		return self
			.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
	
	public var cleaned: String {
		return self
			.replacingOccurrences(of: "\n", with: "")
			.replacingOccurrences(of: "\t", with: "")
			.replacingOccurrences(of: "\r", with: "")
			.replacingOccurrences(of: "    ", with: "")
	}
	
}

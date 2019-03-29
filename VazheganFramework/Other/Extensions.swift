//
//  Extensions.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation
import IDExt

extension UIColor {
	
	public static var V: UIColor {
		return UIColor.ID_Initialize(hexCode: "#4527A0")
	}
	
}

extension String {
	
	public var cleanedFromInvalidPersianCharacters: String {
		return self
			.replacingOccurrences(of: "ي", with: "ی")
			.replacingOccurrences(of: "ك", with: "ک")
			.replacingOccurrences(of: "ى", with: "ی")
	}
	
	public var cleanedFromSpacesAndTabs: String {
		return self
			.replacingOccurrences(of: "\n", with: "")
			.replacingOccurrences(of: "\t", with: "")
			.replacingOccurrences(of: "\r", with: "")
			.replacingOccurrences(of: "    ", with: "")
	}
	
}

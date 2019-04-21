//
//  Extensions+String.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

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
	
	public var trimmed: String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}

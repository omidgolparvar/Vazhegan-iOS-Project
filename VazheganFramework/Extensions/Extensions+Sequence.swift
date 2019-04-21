//
//  Extensions+Sequence.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

public extension Sequence {
	
	public func sorted <T: Comparable> (by keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
		return sorted { a, b in
			if ascending {
				return a[keyPath: keyPath] <= b[keyPath: keyPath]
			} else {
				return a[keyPath: keyPath] > b[keyPath: keyPath]
			}
		}
	}
}

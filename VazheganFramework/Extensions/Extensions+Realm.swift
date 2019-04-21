//
//  Extensions+Realm.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation
import RealmSwift

internal extension Realm {
	
	internal func safeWrite(_ block: (() throws -> Void)) {
		autoreleasepool {
			try! V.RealmObject.write {
				try! block()
			}
		}
	}
	
}

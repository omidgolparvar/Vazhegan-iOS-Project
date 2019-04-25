//
//  Query.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/2/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation
import RealmSwift

public final class Query: Object {
	
	public override static func primaryKey() -> String? {
		return "uuid"
	}
	
	public override static func ignoredProperties() -> [String] {
		return []
	}
	
	@objc dynamic public var uuid			: String	= ""
	@objc dynamic public var query			: String	= ""
	@objc dynamic public var requestDate	: Date	= Date()
	
	public convenience init(query: String) {
		self.init()
		self.uuid			= UUID().uuidString
		self.query			= query
		self.requestDate	= Date()
	}
	
	public func setLastRequestDateToNow() {
		V.RealmObject.safeWrite {
			self.requestDate = Date()
		}
	}
	
	public func save() {
		V.RealmObject.safeWrite {
			V.RealmObject.add(self)
		}
	}
	
	public func delete() {
		V.RealmObject.safeWrite {
			V.RealmObject.delete(self)
		}
	}
}

extension Query {
	
	public static var All: [Query] {
		var array: [Query] = []
		V.RealmObject.objects(Query.self)
			.sorted(by: \.requestDate, ascending: false)
			.forEach { array.append($0) }
		return array
	}
	
	public static func DeleteAll() {
		let allQueries = V.RealmObject.objects(Query.self)
		V.RealmObject.safeWrite {
			V.RealmObject.delete(allQueries)
		}
	}
	
}

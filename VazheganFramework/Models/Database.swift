//
//  Database.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 3/29/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation
import RealmSwift

public final class Database: Object {
	
	public override static func primaryKey() -> String? {
		return "identifier"
	}
	
	public override static func ignoredProperties() -> [String] {
		return []
	}
	
	@objc dynamic public var identifier	: String	= ""
	@objc dynamic public var name		: String	= ""
	@objc dynamic public var isEnabled	: Bool		= true
	
	public convenience init(identifier: String, name: String) {
		self.init()
		self.identifier	= identifier
		self.name		= name
		self.isEnabled	= true
	}
	
	public func toggleIsEnable() {
		V.RealmObject.safeWrite {
			self.isEnabled.toggle()
		}
	}
	
}

public extension Database {
	
	internal static func Setup() {
		let allDatabasesDictionary: [String: (identifier: String, name: String)] = [
			"dehkhoda"		: ("dehkhoda", "لغت‌نامهٔ دهخدا"),
			"moein"			: ("moein", "فرهنگ فارسی معین"),
			"amid"			: ("amid", "فرهنگ فارسی عمید"),
			"motaradef"		: ("motaradef", "واژگان مترادف و متضاد"),
			"farhangestan"	: ("farhangestan","فرهنگ واژه‌های مصوّب فرهنگستان"),
			"sareh"			: ("sareh", "واژه‌های فارسی سره"),
			"ganjvajeh"		: ("ganjvajeh", "فرهنگ گنجواژه"),
			"slang"			: ("slang", "اصطلاحات عامیانه"),
			"quran"			: ("quran", "فرهنگ واژگان قرآن"),
			"name"			: ("name", "فرهنگ نام‌ها"),
			"thesis"		: ("thesis", "فرهنگ لغات علمی"),
			"wiki"			: ("wiki", "ویکی"),
			"isfahani"		: ("isfahani", "لهجه و گویش اصفهانی"),
			"bakhtiari"		: ("bakhtiari", "لهجه و گویش بختیاری"),
			"tehrani"		: ("tehrani", "لهجه و گویش تهرانی"),
			"dezfuli"		: ("dezfuli", "لهجه و گویش دزفولی"),
			"gonabadi"		: ("gonabadi", "لهجه و گویش گنابادی"),
			"mazani"		: ("mazani", "لهجه و گویش مازنی"),
			"en2Fa"			: ("en2Fa", "دیکشنری انگلیسی به پارسی"),
			"ar2Fa"			: ("ar2Fa", "دیکشنری عربی به پارسی"),
			"fa2En"			: ("fa2En", "دیکشنری پارسی به انگلیسی"),
			"fa2Ar"			: ("fa2Ar", "دیکشنری پارسی به عربی"),
		]
		
		var allDatabasesIdentifiers: [String: Bool] = [:]
		allDatabasesDictionary
			.keys
			.forEach { allDatabasesIdentifiers[$0] = false }
		
		V.RealmObject.objects(Database.self)
			.forEach { allDatabasesIdentifiers[$0.identifier] = true }
		
		let newDatabases = allDatabasesIdentifiers
			.filter { !$0.value }
			.keys
			.compactMap { allDatabasesDictionary[$0] }
			.map { Database(identifier: $0.identifier, name: $0.name) }
		
		V.RealmObject.safeWrite {
			V.RealmObject.add(newDatabases)
		}
		
	}
	
	public static var All: [Database] {
		var array: [Database] = []
		V.RealmObject.objects(Database.self).forEach { array.append($0) }
		return array
	}
	
}



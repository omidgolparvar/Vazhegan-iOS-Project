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
	
}

public extension Database {
	
	public static func SetupDatabases() {
		#warning("باید پایگاه داده‌های جدید رو تشخیص بدم و اونا رو ذخیره کنم.")
		
		#warning("پایگاه داده‌های مورد نظر باید اسم داشته باشن.")
		//wiki, isfahani, bakhtiari, tehrani, dezfuli, gonabadi, mazani, en2Fa, ar2Fa, fa2En, fa2Ar
		
		
		let array: [(identifier: String, name: String)] = [
			("dehkhoda", "لغت‌نامهٔ دهخدا"),
			("moein", "فرهنگ فارسی معین"),
			("amid", "فرهنگ فارسی عمید"),
			("motaradef", "واژگان مترادف و متضاد"),
			("farhangestan","فرهنگ واژه‌های مصوّب فرهنگستان"),
			("sareh", "واژه‌های فارسی سره"),
			("ganjvajeh", "فرهنگ گنجواژه"),
			("slang", "اصطلاحات عامیانه"),
			("quran", "فرهنگ واژگان قرآن"),
			("name", "فرهنگ نام‌ها"),
			("thesis", "فرهنگ لغات علمی"),
		]
		
	}
	
}



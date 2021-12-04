import Foundation
import RealmSwift

public final class Database: Object {
	
	@Persisted(primaryKey: true)
	public private(set) var identifier: String = ""
	
	@Persisted
	public private(set) var name: String = ""
	
	@Persisted
	public internal(set) var isEnabled: Bool = true
	
	public convenience init(identifier: String, name: String, isEnabled: Bool = true) {
		self.init()
		self.identifier = identifier
		self.name = name
		self.isEnabled = isEnabled
	}
	
}

extension Database {
	
	static var supportedDatabases: [Database] {
		[
			Database(identifier: "dehkhoda", name: "لغت‌نامهٔ دهخدا", isEnabled: true),
			Database(identifier: "moein", name: "فرهنگ فارسی معین", isEnabled: true),
			Database(identifier: "amid", name	: "فرهنگ فارسی عمید", isEnabled: true),
			Database(identifier: "motaradef", name: "واژگان مترادف و متضاد", isEnabled: true),
			Database(identifier: "farhangestan", name: "فرهنگ واژه‌های مصوّب فرهنگستان", isEnabled: true),
			Database(identifier: "sareh", name: "واژه‌های فارسی سره", isEnabled: true),
			Database(identifier: "ganjvajeh", name: "فرهنگ گنجواژه", isEnabled: true),
			Database(identifier: "slang", name: "اصطلاحات عامیانه", isEnabled: true),
			Database(identifier: "quran", name: "فرهنگ واژگان قرآن", isEnabled: false),
			Database(identifier: "name", name: "فرهنگ نام‌ها", isEnabled: true),
			Database(identifier: "thesis", name: "فرهنگ لغات علمی", isEnabled: false),
			Database(identifier: "wiki", name: "ویکی", isEnabled: true),
			Database(identifier: "isfahani", name: "لهجه و گویش اصفهانی", isEnabled: false),
			Database(identifier: "bakhtiari", name: "لهجه و گویش بختیاری", isEnabled: false),
			Database(identifier: "tehrani", name: "لهجه و گویش تهرانی", isEnabled: false),
			Database(identifier: "dezfuli", name: "لهجه و گویش دزفولی", isEnabled: false),
			Database(identifier: "gonabadi", name: "لهجه و گویش گنابادی", isEnabled: false),
			Database(identifier: "mazani", name: "لهجه و گویش مازنی", isEnabled: false),
			Database(identifier: "en2Fa", name: "دیکشنری انگلیسی به پارسی", isEnabled: true),
			Database(identifier: "ar2Fa", name: "دیکشنری عربی به پارسی", isEnabled: true),
			Database(identifier: "fa2En", name: "دیکشنری پارسی به انگلیسی", isEnabled: true),
			Database(identifier: "fa2Ar", name: "دیکشنری پارسی به عربی", isEnabled: true),
		]
	}
	
}

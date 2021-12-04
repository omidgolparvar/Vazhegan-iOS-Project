import Foundation
import RealmSwift

public final class Word: Object {
	
	@Persisted(primaryKey: true)
	public private(set) var id: String = ""
	
	@Persisted
	public private(set) var titlePersian: String = ""
	
	@Persisted
	public private(set) var titleEnglish: String = ""
	
	@Persisted
	public private(set) var db: String = ""
	
	@Persisted
	public internal(set) var text: String = ""
	
	@Persisted
	public private(set) var source: String = ""
	
	@Persisted
	public private(set) var number: Int = 0
	
	@Persisted
	public private(set) var pronounce: String = ""
	
	@Persisted
	public internal(set) var fullText: String = ""
	
	public var hasFullMeaning: Bool {
		!fullText.isEmpty
	}
	
	public var nonEmptyTitle: String {
		[titlePersian.trimmed, titleEnglish.trimmed].first(where: { !$0.isEmpty }) ?? ""
	}
	
	public lazy var database: Database = {
		Database.supportedDatabases.first(where: { $0.identifier.lowercased() == db.lowercased() })!
	}()
	
}

extension CodingUserInfoKey {
	static let isForGetWordMeaning = CodingUserInfoKey(rawValue: "Vazhegan.isForGetWordMeaning")!
}

extension Word: Decodable {
	
	public convenience init(from decoder: Decoder) throws {
		self.init()
		
		let isForGetMeaning = (decoder.userInfo[.isForGetWordMeaning] as? Bool) ?? false
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try container.decode(String.self, forKey: .id)
		self.titlePersian = try container.decode(String.self, forKey: .titlePersian)
		self.titleEnglish = try container.decode(String.self, forKey: .titleEnglish)
		self.text = try container.decode(String.self, forKey: .text)
		self.source = try container.decode(String.self, forKey: .source)
		self.db = try container.decode(String.self, forKey: .db)
		
		if isForGetMeaning {
			self.pronounce = try container.decode(String.self, forKey: .pronounce)
			self.fullText = try container.decode(String.self, forKey: .text)
		} else {
			self.number = try container.decode(Int.self, forKey: .number)
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case titlePersian = "title"
		case titleEnglish = "title_en"
		case text = "text"
		case source = "source"
		case db = "db"
		case number = "num"
		case pronounce = "pron"
	}
	
}

extension Word {
	
	internal convenience init(copyOf word: Word) {
		self.init()
		self.id				= word.id
		self.titlePersian	= word.titlePersian
		self.titleEnglish	= word.titleEnglish
		self.db				= word.db
		self.text			= word.text
		self.source			= word.source
		self.number			= word.number
		self.pronounce		= word.pronounce
		self.fullText		= word.fullText
	}
	
}

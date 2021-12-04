//

import Foundation

protocol DictionaryRepresentable {
	var asDictionary: [String: Any] { get }
}

extension DictionaryRepresentable where Self: Encodable {
	var asDictionary: [String: Any] {
		guard let data = try? JSONEncoder().encode(self),
			  let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
			  let dictionary = jsonObject as? [String: Any]
		else { return [:] }
		return dictionary
	}
}

struct SearchRequest: Encodable {
	static var defaultNumberOfResult: Int = 30
	
	let token: String
	let query: String
	let type: SearchQueryType
	let start: Int = 0
	let rows: Int = Self.defaultNumberOfResult
	let databases: String
	
	enum CodingKeys: String, CodingKey {
		case token = "token"
		case query = "q"
		case type = "type"
		case start = "start"
		case rows = "rows"
		case databases = "filter"
	}
	
}
extension SearchRequest: DictionaryRepresentable {}

public enum SearchQueryType: String, CaseIterable, Encodable {
	case exact
	case ava
	case like
	case text
	
	public init?(intValue: Int) {
		switch intValue {
		case 0	: self = .exact
		case 1	: self = .ava
		case 2	: self = .like
		case 3	: self = .text
		default	: return nil
		}
	}
	
	public var persian: String {
		switch self {
		case .ava: return "واژگان هم‌آوا"
		case .exact: return "واژگان دقیق"
		case .like: return "واژگان مشابه"
		case .text: return "واژگان در معانی"
		}
	}
}

struct GetMeaningRequest: Encodable {
	let token: String
	let title: String
	let database: String
	let number: Int
	
	enum CodingKeys: String, CodingKey {
		case token = "token"
		case title = "title"
		case database = "db"
		case number = "num"
	}
}
extension GetMeaningRequest: DictionaryRepresentable {}

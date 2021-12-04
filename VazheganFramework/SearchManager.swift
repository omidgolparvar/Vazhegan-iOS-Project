//

import Foundation
import Combine

public typealias SearchPublisher = AnyPublisher<SearchResult, Error>

public protocol SearchManager {
	func search(text: String) -> SearchPublisher
}

public class SearchResult {
	public let query: String
	public let exact: Group
	public let ava: Group
	public let like: Group
	public let text: Group
	
	public init(query: String, exact: Group, ava: Group, like: Group, text: Group) {
		self.query = query
		self.exact = exact
		self.ava = ava
		self.like = like
		self.text = text
	}
	
	public class Group {
		public let queryType: SearchQueryType
		public let results: [Word]
		
		public init(queryType: SearchQueryType, results: [Word]) {
			self.queryType = queryType
			self.results = results
		}
	}
}

public final class DefaultSearchManager {
	private let networkManager: NetworkManager
	private let databaseManager: DatabaseManager
	private let queryManager: QueryManager
	
	public init(
		networkManager: NetworkManager,
		databaseManager: DatabaseManager,
		queryManager: QueryManager
	) {
		self.networkManager = networkManager
		self.databaseManager = databaseManager
		self.queryManager = queryManager
	}
}

extension DefaultSearchManager: SearchManager {
	
	public func search(text: String) -> SearchPublisher {
		queryManager.saveQuery(Query(query: text))
		let text = cleanedText(text: text)
		let databases = databaseManager.getEnabledDatabases()
		let publishers = [SearchQueryType.exact, .ava, .like, .text].map { queryType in
			networkManager
				.search(query: text, queryType: queryType, in: databases)
				.map { SearchResult.Group(queryType: queryType, results: $0) }
				.eraseToAnyPublisher()
		}
		
		return Publishers
			.Zip4(publishers[0], publishers[1], publishers[2], publishers[3])
			.map { SearchResult(query: text, exact: $0.0, ava: $0.1, like: $0.2, text: $0.3) }
			.eraseToAnyPublisher()
	}
	
	func cleanedText(text: String) -> String {
		return text.trimmed
	}
	
}

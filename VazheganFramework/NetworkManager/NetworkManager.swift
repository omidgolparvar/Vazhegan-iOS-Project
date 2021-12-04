import Foundation
import Combine

public typealias SearchResultPublisher = AnyPublisher<[Word], Error>
public typealias GetMeaningResultPublisher = AnyPublisher<Word, Error>

public protocol NetworkManager {
	func search(query: String, queryType: SearchQueryType, in databases: [Database]) -> SearchResultPublisher
	func getMeaning(of word: Word) -> GetMeaningResultPublisher
}

import Foundation
import Moya
import Combine

public final class MoyaNetworkManager {
	typealias Provider = MoyaProvider<VajeyabService>
	
	public static var `default`: MoyaNetworkManager {
		let provider = Provider(
			plugins: [
				//NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
			]
		)
		return MoyaNetworkManager(
			provider: provider,
			apiToken: V.Constants.token
		)
	}
	
	private let provider: Provider
	private let apiToken: String
	
	init(provider: Provider, apiToken: String) {
		self.provider = provider
		self.apiToken = apiToken
	}
	
}

extension MoyaNetworkManager: NetworkManager {
	public func search(query: String, queryType: SearchQueryType, in databases: [Database]) -> SearchResultPublisher {
		let payload = SearchRequest(
			token: apiToken,
			query: query,
			type: queryType,
			databases: databases.map { $0.identifier }.joined(separator: ",")
		)
		
		return provider
			.requestPublisher(.search(payload))
			.decode(as: SearchResponse.self)
			.map(\.results)
			.eraseToAnyPublisher()
	}
	
	public func getMeaning(of word: Word) -> GetMeaningResultPublisher {
		let payload = GetMeaningRequest(
			token: apiToken,
			title: word.nonEmptyTitle,
			database: word.db,
			number: word.number
		)
		
		let decoder = JSONDecoder()
		decoder.userInfo[.isForGetWordMeaning] = true
		
		return provider
			.requestPublisher(.getMeaning(payload))
			.decode(as: GetMeaningResponse.self, using: decoder)
			.map(\.word)
			.eraseToAnyPublisher()
	}
	
}

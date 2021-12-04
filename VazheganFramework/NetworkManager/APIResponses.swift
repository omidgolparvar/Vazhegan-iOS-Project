//

import Foundation

struct SearchResponse: Decodable {
	let results: [Word]
	
	init(from decoder: Decoder) throws {
		let rootContainer = try decoder.container(keyedBy: RootKeys.self)
		let dataContainer = try rootContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
		self.results = try dataContainer.decode([Word].self, forKey: .results)
	}
	
	enum RootKeys: String, CodingKey {
		case data
	}
	
	enum DataKeys: String, CodingKey {
		case results
	}
}

struct GetMeaningResponse: Decodable {
	let word: Word
}

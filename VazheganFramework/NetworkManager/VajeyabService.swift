import Foundation
import Moya

enum VajeyabService {
	case search(SearchRequest)
	case getMeaning(GetMeaningRequest)
}

extension VajeyabService: TargetType {
	
	var baseURL: URL {
		return URL(string: V.Constants.apiURL)!
	}
	
	var path: String {
		switch self {
		case .search:
			return "/search"
		case .getMeaning:
			return "/word"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .search,
			 .getMeaning:
			return .get
		}
	}
	
	var task: Task {
		switch self {
		case .search(let request as DictionaryRepresentable),
			 .getMeaning(let request as DictionaryRepresentable):
			return .requestParameters(parameters: request.asDictionary, encoding: URLEncoding.queryString)
		}
	}
	
	var headers: [String : String]? {
		switch self {
		case .search,
			 .getMeaning:
			return nil
		}
	}
	
}

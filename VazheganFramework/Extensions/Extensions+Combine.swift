import Foundation
import Combine
import Moya

extension Publisher where Output == Moya.Response {
	
	func decode<Model: Decodable>(as Model: Model.Type, using decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Model, Error>  {
		return self
			.map(\.data)
			.tryMap { try decoder.decode(Model.self, from: $0) }
			.eraseToAnyPublisher()
	}
	
}

extension Publisher {
	
	func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
		return self
			.map { Result<Output, Failure>.success($0) }
			.catch { Just(Result<Output, Failure>.failure($0)) }
			.eraseToAnyPublisher()
	}
	
}

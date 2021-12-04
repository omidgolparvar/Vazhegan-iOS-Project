//

import Foundation
import Combine
import VazheganFramework

final class ViewModel {
	
	private var searchCancellable: AnyCancellable?
	private let searchManager: SearchManager
	
	@Published private(set) var searchStatus = SearchStatus.notRequested
	
	init(searchManager: SearchManager) {
		self.searchManager = searchManager
	}
	
	func search(text: String) {
		if case .success(let result) = searchStatus {
			guard result.query != text else { return }
		}
		
		searchCancellable?.cancel()
		searchStatus = .searching(text)
		searchCancellable = searchManager
			.search(text: text)
			.sink(receiveCompletion: { [weak self] (completion) in
				guard let self = self else { return }
				
				switch completion {
				case .failure(let error):
					self.searchStatus = .failed(error)
				case .finished:
					break
				}
			}, receiveValue: { [weak self] (result) in
				guard let self = self else { return }
				
				self.searchStatus = .success(result)
			})
	}
	
	func cancelSearch() {
		searchStatus = .notRequested
	}
	
}

enum SearchStatus {
	case notRequested
	case searching(String)
	case success(SearchResult)
	case failed(Error)
}

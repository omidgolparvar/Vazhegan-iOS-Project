//

import Foundation
import Combine
import VazheganFramework

extension MainScene {
	
	final class ViewModel: SceneViewModel {
		
		private var searchCancellable: AnyCancellable?
		private let searchManager: SearchManager
		
		@Published private(set) var searchStatus = SearchStatus.notRequested
		
		init(searchManager: SearchManager) {
			self.searchManager = searchManager
		}
		
		func search(text: String) {
			if case .success(let result) = searchStatus, result.query == text {
				return
			}
			
			searchCancellable?.cancel()
			searchStatus = .searching(text)
			searchCancellable = searchManager
				.search(text: text)
				.sink(receiveCompletion: { [weak self] (completion) in
					guard let self = self, case .failure(let error) = completion else { return }
					
					self.searchStatus = .failed(error)
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
	
}

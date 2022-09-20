//

import Foundation
import Combine
import VazheganFramework

extension HistoryScene {
	
	final class ViewModel: SceneViewModel {
		private let queryManager: QueryManager
		
		@Published private(set) var queries: [Query]
		
		init(queryManager: QueryManager) {
			self.queryManager = queryManager
			self.queries = queryManager.getAllQueries()
		}
		
		func removeQuery(at index: Int) {
			let query = queries.remove(at: index)
			queryManager.deleteQuery(query)
		}
		
		func removeQuery(_ query: Query) {
			guard let index = queries.firstIndex(of: query) else { return }
			removeQuery(at: index)
		}
	}
	
}

import Foundation

public protocol QueryManager {
	func getAllQueries() -> [Query]
	func resetLastRequestDate(for query: Query)
	func saveQuery(_ query: Query)
	func deleteQuery(_ query: Query)
	var numberOfQueriesToStore: Int { get }
	func deleteOlderQueries()
}

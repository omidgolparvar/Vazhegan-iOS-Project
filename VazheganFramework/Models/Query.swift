import Foundation
import RealmSwift

public final class Query: Object {
	
	@Persisted(primaryKey: true)
	public private(set) var uuid: UUID = UUID()
	
	@Persisted
	public private(set) var query: String = ""
	
	@Persisted
	public internal(set) var lastRequestDate: Date = Date()
	
	public convenience init(query: String) {
		self.init()
		self.query = query.trimmed
	}
	
}

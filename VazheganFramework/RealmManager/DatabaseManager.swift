import Foundation

public protocol DatabaseManager {
	static var isDatabasesPrepared: Bool { get set }
	func prepareDatabases()
	func getAllDatabases() -> [Database]
	func getEnabledDatabases() -> [Database]
	func setEnabled(_ isEnabled: Bool, for database: Database)
}

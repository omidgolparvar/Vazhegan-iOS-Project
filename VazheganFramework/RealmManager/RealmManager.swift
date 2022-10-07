import Foundation
import RealmSwift

public final class RealmManager {
	
	public static var `default`: RealmManager {
		return RealmManager()
	}
	
	var realm: Realm {
		getRealmObject()
	}
	
	init() {
		prepareDatabases()
		cleanup()
	}
	
	private func getRealmObject() -> Realm {
		var config = Realm.Configuration()
		config.fileURL = FileManager
			.default
			.containerURL(forSecurityApplicationGroupIdentifier: V.Constants.appGroupIdentifier)!
			.appendingPathComponent("db.realm")
		config.schemaVersion = 3
		config.migrationBlock = { _, _ in }
		Realm.Configuration.defaultConfiguration = config
		
		return try! Realm()
	}
	
	private func cleanup() {
		deleteOlderQueries()
	}
}

extension RealmManager: DatabaseManager {
	
	public static var isDatabasesPrepared: Bool = false
	
	public func prepareDatabases() {
		guard !Self.isDatabasesPrepared else { return }
		defer {
			Self.isDatabasesPrepared = true
		}
		
		let currentDatabases = Set(getAllDatabases())
		let currentDatabasesIdentifiers = currentDatabases.map({ $0.identifier })
		let supportedDatabases = Database.supportedDatabases
		
		let realm = self.realm
		for database in supportedDatabases {
			if !currentDatabasesIdentifiers.contains(database.identifier) {
				print("Add Database:", database.identifier)
				realm.safeWrite {
					realm.add(database, update: .all)
				}
			}
		}
	}
	
	public func getAllDatabases() -> [Database] {
		realm
			.objects(Database.self)
			.map { $0 }
	}
	
	public func getEnabledDatabases() -> [Database] {
		realm
			.objects(Database.self)
			.filter(NSPredicate(format: "isEnabled == YES"))
			.map { $0 }
	}
	
	public func setEnabled(_ isEnabled: Bool, for database: Database) {
		realm.safeWrite {
			database.isEnabled = isEnabled
		}
	}
	
}

extension RealmManager: QueryManager {
	
	public var numberOfQueriesToStore: Int { 100 }
	
	public func getAllQueries() -> [Query] {
		realm
			.objects(Query.self)
			.sorted(by: \.lastRequestDate, ascending: false)
	}
	
	public func resetLastRequestDate(for query: Query) {
		realm.safeWrite {
			query.lastRequestDate = Date()
		}
	}
	
	public func saveQuery(_ query: Query) {
		let realm = self.realm
		let predicate = NSPredicate(format: "query == %@", query.query)
		if let existingQuery = realm.objects(Query.self).filter(predicate).first {
			resetLastRequestDate(for: existingQuery)
		} else {
			realm.safeWrite {
				realm.add(query, update: .all)
			}
		}
	}
	
	public func deleteQuery(_ query: Query) {
		let realm = self.realm
		realm.safeWrite {
			realm.delete(query)
		}
	}
	
	public func deleteOlderQueries() {
		let realm = self.realm
		let allQueries = realm
			.objects(Query.self)
			.sorted(by: \.lastRequestDate, ascending: false)
		
		guard allQueries.count > numberOfQueriesToStore else { return }
		
		var queriesToDelete: [Query] = []
		allQueries[numberOfQueriesToStore...].forEach {
			queriesToDelete.append($0)
		}
		
		realm.safeWrite {
			realm.delete(queriesToDelete)
		}
	}
	
}

extension RealmManager: WordManager {
	
	public func getMyWords() -> [Word] {
		realm.objects(Word.self).reversed()
	}
	
	public func deleteWord(_ word: Word) {
		let realm = self.realm
		realm.safeWrite {
			realm.delete(word)
		}
	}
	
	public func copyWord(of word: Word) -> Word {
		Word(copyOf: word)
	}
	
	public func isWordInMyWords(_ word: Word) -> Bool {
		realm.object(ofType: Word.self, forPrimaryKey: word.id) != nil
	}
	
	public func addWordToMyWords(_ word: Word) {
		let realm = self.realm
		realm.safeWrite {
			realm.add(word, update: .all)
		}
	}
	
	public func removeWordFromMyWords(_ word: Word) {
		guard let object = realm.object(ofType: Word.self, forPrimaryKey: word.id) else { return }
		let realm = self.realm
		realm.safeWrite {
			realm.delete(object)
		}
	}
	
	public func database(for word: Word) -> Database {
		guard let database = realm.object(ofType: Database.self, forPrimaryKey: word.db) else {
			fatalError("\(#function) - Invalid Database: \(word.db)")
		}
		return database
	}
	
	public func setTexts(for word: Word, basedOn anotherWord: Word) {
		let realm = self.realm
		realm.safeWrite {
			word.text = anotherWord.text
		}
	}
}

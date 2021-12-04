//

import Foundation
import Combine
import VazheganFramework

extension DatabasesScene {
	
	final class ViewModel: SceneViewModel {
		
		private let databaseManager: DatabaseManager
		
		@Published private(set) var databases: [Database]
		
		init(databaseManager: DatabaseManager) {
			self.databaseManager = databaseManager
			self.databases = databaseManager.getAllDatabases()
		}
		
		func setEnabled(_ isEnabled: Bool, for database: Database) {
			print(#function, "Before", isEnabled, database.identifier, database.isEnabled)
			databaseManager.setEnabled(isEnabled, for: database)
			print(#function, "After", isEnabled, database.identifier, database.isEnabled)
		}
		
	}

}

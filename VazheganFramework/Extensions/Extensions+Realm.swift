import Foundation
import RealmSwift

internal extension Realm {
	
	func safeWrite(_ block: (() throws -> Void)) {
		autoreleasepool {
			try! self.write {
				try! block()
			}
		}
	}
	
}

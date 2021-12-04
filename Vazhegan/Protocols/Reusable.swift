//

import UIKit

protocol Reusable: AnyObject {
	static var reuseIdentifier: String { get }
}

extension Reusable {
	static var reuseIdentifier: String { String(describing: Self.self) }
}

//

import Foundation
import UIKit

infix operator ..
@inline(__always)
func ..<T: AnyObject> (lhs: T, rhs: (T) -> Void) -> T {
	rhs(lhs)
	return lhs
}

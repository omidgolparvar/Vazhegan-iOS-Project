//

import Foundation
import UIKit

extension NSAttributedString {
	
	convenience init(_ string: String, font: UIFont, textColor: UIColor) {
		self.init(string: string, attributes: [
			.font: font,
			.foregroundColor: textColor
		])
	}
	
}

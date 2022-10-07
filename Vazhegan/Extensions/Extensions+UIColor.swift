//

import Foundation
import UIKit

extension UIColor {
	
	convenience init(lightMode: UIColor, darkMode: UIColor) {
		self.init { (traitCollection) -> UIColor in
			traitCollection.userInterfaceStyle == .dark ? darkMode : lightMode
		}
	}
	
}

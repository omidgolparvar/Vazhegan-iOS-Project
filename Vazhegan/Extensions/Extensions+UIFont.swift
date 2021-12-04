//

import UIKit

extension UIFont {
	
	static func pinar(size: CGFloat, weight: Weight = .regular) -> UIFont {
		var fontName = "Pinar-"
		switch weight {
		case .heavy			: fontName += "ExtraBold"
		case .black			: fontName += "Black"
		case .bold			: fontName += "Bold"
		case .semibold		: fontName += "SemiBold"
		case .medium		: fontName += "Medium"
		case .regular		: fontName += "Regular"
		case .light,
			 .thin,
			 .ultraLight	: fontName += "Light"
		default				: fontName += "Regular"
		}
		
		return UIFont(name: fontName, size: size)!
	}
	
}

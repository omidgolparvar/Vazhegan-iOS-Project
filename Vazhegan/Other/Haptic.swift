//

import Foundation
import UIKit

enum Haptic {
	
	enum HapticFeedbackStyle: Int {
		case light, medium, heavy
		
		var value: UIImpactFeedbackGenerator.FeedbackStyle {
			return UIImpactFeedbackGenerator.FeedbackStyle(rawValue: rawValue)!
		}
	}
	
	enum HapticFeedbackType: Int {
		case success, warning, error
		
		var value: UINotificationFeedbackGenerator.FeedbackType {
			return UINotificationFeedbackGenerator.FeedbackType(rawValue: rawValue)!
		}
	}
	
	
	case impact(HapticFeedbackStyle)
	case notification(HapticFeedbackType)
	case selection
	
	func generate() {
		switch self {
		case .impact(let style):
			let generator = UIImpactFeedbackGenerator(style: style.value)
			generator.prepare()
			generator.impactOccurred()
		case .notification(let type):
			let generator = UINotificationFeedbackGenerator()
			generator.prepare()
			generator.notificationOccurred(type.value)
		case .selection:
			let generator = UISelectionFeedbackGenerator()
			generator.prepare()
			generator.selectionChanged()
		}
	}
}

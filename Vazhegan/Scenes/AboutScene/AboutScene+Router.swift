//

import UIKit
import VazheganFramework

extension AboutScene {
	
	final class Router: SceneRouter {
		weak var sourceController: UIViewController?
		var dataProvider: Void? = nil
		
		func openURL(_ url: URL) {
			guard UIApplication.shared.canOpenURL(url) else { return }
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		
	}
	
	struct SocialNetwork {
		let name: String
		let link: URL
		let color: UIColor
		
		static let linkedIn = SocialNetwork(
			name: "لینکدین",
			link: URL(string: "https://www.linkedin.com/in/omidgolparvar")!,
			color: #colorLiteral(red: 0.05490196078, green: 0.462745098, blue: 0.6588235294, alpha: 1)
		)
		
		static let github = SocialNetwork(
			name: "گیت‌‌هاب",
			link: URL(string: "https://github.com/omidgolparvar")!,
			color: .label
		)
		
	}
	
}

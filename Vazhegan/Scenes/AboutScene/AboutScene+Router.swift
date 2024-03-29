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
		
		func presentShareController(with items: [Any]) {
			let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
			activityController.popoverPresentationController?.sourceView = sourceController?.view
			activityController.popoverPresentationController?.permittedArrowDirections = []
			sourceController?.present(activityController, animated: true, completion: nil)
		}
		
	}
	
	struct SocialNetwork {
		let name: String
		let link: URL
		let color: UIColor
		
		static let linkedIn = SocialNetwork(
			name: R.string.aboutScene.linkedinLinkTitle(),
			link: V.Constants.myLinkedInProfileURL,
			color: #colorLiteral(red: 0.05490196078, green: 0.462745098, blue: 0.6588235294, alpha: 1)
		)
		
	}
	
}

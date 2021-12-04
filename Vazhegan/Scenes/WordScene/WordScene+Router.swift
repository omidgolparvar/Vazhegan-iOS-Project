//

import UIKit
import VazheganFramework

extension WordScene {
	
	final class Router: SceneRouter {
		weak var sourceController: UIViewController?
		var dataProvider: Void? = nil
		
		func openVajehyabWebsite(for word: Word) {
			var urlComponents = URLComponents(string: V.Constants.vajehyabWebsiteURL)
			urlComponents?.queryItems = [.init(name: "q", value: word.nonEmptyTitle)]
			
			guard
				let url = urlComponents?.url,
				UIApplication.shared.canOpenURL(url)
			else { return }
			
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		
		func presentShareController(with items: [Any]) {
			let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
			activityController.popoverPresentationController?.sourceView = sourceController?.view
			activityController.popoverPresentationController?.permittedArrowDirections = []
			sourceController?.present(activityController, animated: true, completion: nil)
		}
	}
	
}

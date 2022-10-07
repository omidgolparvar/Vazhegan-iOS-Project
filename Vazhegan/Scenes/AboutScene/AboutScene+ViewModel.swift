//

import Foundation
import Combine
import VazheganFramework

extension AboutScene {
	
	final class ViewModel: SceneViewModel {
		
		var shareText: String {
			return "📱 واژگان" + "\n\n" + V.Constants.appDownloadLink
		}
		
	}

}

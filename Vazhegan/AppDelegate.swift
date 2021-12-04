import UIKit
import VazheganFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		UIView.appearance().semanticContentAttribute = .forceRightToLeft
		
		window = UIWindow()
		window?.rootViewController = MainScene.initialize()
		window?.makeKeyAndVisible()
		
		return true
	}
	
}

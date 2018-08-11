//
//  AppDelegate.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 1/14/17.
//  Copyright © 2017 Omid Golparvar. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import VazheganFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		UINavigationBar.appearance().titleTextAttributes = [
			NSAttributedStringKey.font:UIFont(name: "IRANSansMobile-Medium", size: 18)!,
			NSAttributedStringKey.foregroundColor: UIColor(hexCode: "#4527A0")
		]
		UIBarButtonItem.appearance().setTitleTextAttributes(
			[NSAttributedStringKey.font: UIFont(name: "IRANSansMobile-Bold", size: 18)!],
			for: UIControlState()
		)
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
			NSAttributedStringKey.font.rawValue: UIFont(name: "IRANSansMobile", size: 14)!,
		]
		
		Fabric.with([Crashlytics.self])
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UIStoryboard(name: "Main", bundle: V.FrameworkBundle)
			.instantiateViewController(withIdentifier: "SearchNavigationController")
		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {}

	func applicationDidEnterBackground(_ application: UIApplication) {}

	func applicationWillEnterForeground(_ application: UIApplication) {}

	func applicationDidBecomeActive(_ application: UIApplication) {}

	func applicationWillTerminate(_ application: UIApplication) {}
	
}


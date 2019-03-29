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
import IDExt

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		setupIDExt()
		setupUIStyles()
		
		//Fabric.with([Crashlytics.self])
		
		return true
	}
	
	private func setupHomeController() {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UIStoryboard(name: "Main", bundle: V.FrameworkBundle)
			.instantiateViewController(withIdentifier: "SearchNavigationController")
		self.window!.rootViewController = navigationController
		self.window!.makeKeyAndVisible()
	}
	
	private func setupIDExt() {
		IDFont.SetFonts(
			black		: UIFont(name: "IRANSansMobile-Bold", size: 16.0)!,
			bold		: UIFont(name: "IRANSansMobile-Bold", size: 16.0)!,
			medium		: UIFont(name: "IRANSansMobile-Medium", size: 16.0)!,
			regular		: UIFont(name: "IRANSansMobile", size: 16.0)!,
			light		: UIFont(name: "IRANSansMobile-Light", size: 16.0)!,
			ultraLight	: UIFont(name: "IRANSansMobile-Light", size: 16.0)!
		)
		UIFont.ID_OverrideInitialize()
	}
	
	private func setupUIStyles() {
		UINavigationBar.ID_SetTitleTextAttributes([
			.font				: UIFont(name: "IRANSansMobile-Medium", size: 18)!,
			.foregroundColor	: UIColor.ID_Initialize(hexCode: "#4527A0")
			]
		)
		
		UIBarButtonItem.ID_SetTitleTextAttributes([.font: UIFont(name: "IRANSansMobile-Bold", size: 18)!], for: .normal)
		UIBarButtonItem.ID_SetTitleTextAttributes([.font: UIFont(name: "IRANSansMobile-Bold", size: 18)!], for: .highlighted)
		UITextField.ID_SetDefaultTextAttributes([.font: UIFont(name: "IRANSansMobile", size: 14)!], whenContainedInInstancesOf: [UISearchBar.self])
		
	}
}


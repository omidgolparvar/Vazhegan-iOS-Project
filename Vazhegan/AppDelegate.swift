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
import IDExt
import VazheganFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		setupIDExt()
		setupUIStyles()
		
		V.Setup()
		
		//Fabric.with([Crashlytics.self])
		
		return true
	}
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		V.HandleIncomingURL(url)
		
		return true
	}
	
}

extension AppDelegate {
	
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
		
		IDMessageBackgroundView.TitleColor = UIColor.V
		IDMessageBackgroundView.TitleFont = IDFont.Medium.withSize(20)
		IDMessageBackgroundView.MessageColor = .black
		IDMessageBackgroundView.MessageFont = IDFont.Regular.withSize(16)
		
	}
	
	private func setupUIStyles() {
		UINavigationBar.ID_SetTitleTextAttributes([
			.font				: IDFont.Bold.withSize(18),
			.foregroundColor	: UIColor.V
			]
		)
		
		UIBarButtonItem.ID_SetTitleTextAttributes([.font: IDFont.Medium.withSize(18)], for: .normal)
		UIBarButtonItem.ID_SetTitleTextAttributes([.font: IDFont.Medium.withSize(18)], for: .highlighted)
		UITextField.ID_SetDefaultTextAttributes([.font: IDFont.Regular.withSize(14)], whenContainedInInstancesOf: [UISearchBar.self])
		
	}
	
}


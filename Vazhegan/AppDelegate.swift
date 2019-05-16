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
import IDPush
import UserNotifications
import IDAlert

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	private var isFabricUsageEnabled	= true
	
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		setupIDPush(application)
		setupIDExt()
		setupIDAlert()
		setupUIStyles()
		setupFabric()
		V.Setup()
		
		return true
	}
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		V.HandleIncomingURL(url)
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
		var tokenString = ""
		for i in 0..<deviceToken.count {
			tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
		}
		print("APNs Token:", tokenString)
		
		IDPush.Perform(action: .addDevice(token: tokenString)) { (error, data) in
			//Requester.PrintJSON(data: data as AnyObject)
			if let error = error {
				print("IDPush.AddDevice: Error: \(error.description)")
				return
			}
			
			guard let playerID = IDPush.GetPlayerID() else { return }
			print("IDPush.AddDevice: Done: \(playerID)")
		}
	}
	
}


extension AppDelegate: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .badge, .sound])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		completionHandler()
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
	
	private func setupIDPush(_ application: UIApplication) {
		IDPush.Setup(projectID: "5cbeec10a71f76285b362b22")
		UNUserNotificationCenter.current().delegate = self
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
			guard granted, error == nil else { return }
			DispatchQueue.main.async {
				application.registerForRemoteNotifications()
			}
		}
	}
	
	private func setupFabric() {
		guard isFabricUsageEnabled else { return }
		Fabric.with([Crashlytics.self, Answers.self])
	}
	
	private func setupIDAlert() {
		IDAlertHeader.TitleFont			= IDFont.Bold.withSize(16)
		IDAlertHeader.MessageFont		= IDFont.Regular.withSize(14)
		
		IDAlertAction.TitleTextFont		= IDFont.Medium.withSize(18)
		IDAlertAction.SubtitleTextFont	= IDFont.Regular.withSize(14)
		
	}
	
}


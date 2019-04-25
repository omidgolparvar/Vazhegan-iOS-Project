//
//  Settings.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/4/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

public final class Settings {
	
	public static var Shared: Settings {
		return Settings()
	}
	
	public var automaticRequestsInAllTypes	: Bool
	public var applicationVersion			: String
	
	private init() {
		let userDefaults = UserDefaults(suiteName: V.AppGroupIdentifier)!
		
		if let value = userDefaults.object(forKey: SettingsUserDefaultsKeys.AutomaticRequestsInAllTypes.rawValue) as? Bool {
			automaticRequestsInAllTypes = value
		} else {
			automaticRequestsInAllTypes = false
			userDefaults.set(false, forKey: SettingsUserDefaultsKeys.AutomaticRequestsInAllTypes.rawValue)
			userDefaults.synchronize()
		}
		
		let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
		let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
		applicationVersion = "v" + version + "(\(buildNumber))"
	}
	
	public func set(automaticRequestsInAllTypes: Bool) {
		let userDefaults = UserDefaults(suiteName: V.AppGroupIdentifier)!
		userDefaults.set(automaticRequestsInAllTypes, forKey: SettingsUserDefaultsKeys.AutomaticRequestsInAllTypes.rawValue)
		userDefaults.synchronize()
		self.automaticRequestsInAllTypes = automaticRequestsInAllTypes
	}
	
	private enum SettingsUserDefaultsKeys: String {
		case AutomaticRequestsInAllTypes	= "V_AutomaticRequestsInAllTypes"
	}
	
}



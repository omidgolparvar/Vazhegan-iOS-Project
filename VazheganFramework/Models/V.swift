//
//  V.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation
import RealmSwift

public class V {
	
	public static let AppDownloadLink	= "https://github.com/omidgolparvar/Vazhegan-iOS-Project/blob/master/Download.md"
	
	static let AppGroupIdentifier	= "group.io.idco.ios.Vazhegan"
	static let ApiURL				= "http://api.vajehyab.com/v3/"
	static let Token				= "42173.bHFRgXvuP5pUYBd766I7nOIAevqv6PVhxB9NyFio"
	
	static var FrameworkBundle: Bundle {
		return Bundle(for: V.self)
	}
	
	static var RealmObject: Realm {
		var config = Realm.Configuration()
		config.fileURL = FileManager
			.default
			.containerURL(forSecurityApplicationGroupIdentifier: AppGroupIdentifier)!
			.appendingPathComponent("db.realm")
		config.schemaVersion = 3
		config.migrationBlock = { _, _ in }
		Realm.Configuration.defaultConfiguration = config
		let realm = try! Realm()
		return realm
	}
	
	public static func Setup() {
		Database.Setup()
		Query.DeleteOldItems()
	}
	
	public static func HandleIncomingURL(_ url: URL) {
		//Pattern > vazhegan://getMeaning/{text}
		
		guard
			let host = url.host?.lowercased(),
			host == "getMeaning".lowercased(),
			url.pathComponents.count >= 2
			else { return }
		
		let text = url.pathComponents[1]
		print("\(#function) - vazhegan://getMeaning/\(text)")
	}
}

//
//  Word.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation
import RealmSwift
import IDExt

public final class Word: Object {
	
	@objc dynamic public var data_id		: String	= ""
	@objc dynamic public var id				: String	= ""
	@objc dynamic public var titlePersian	: String	= ""
	@objc dynamic public var titleEnglish	: String	= ""
	@objc dynamic public var db				: String	= ""
	@objc dynamic public var text			: String	= ""
	@objc dynamic public var source			: String	= ""
	@objc dynamic public var number			: Int		= 0
	
	public convenience init?(from json: IDMoya.JSON) {
		let dynamicJSON = IDDynamicJSON(from: json)
		
		guard
			let _id = dynamicJSON.id?.json?.string,
			let _titlePersian = dynamicJSON.title?.json?.string,
			let _titleEnglish = dynamicJSON.title_en?.json?.string,
			let _text = dynamicJSON.text?.json?.string,
			let _source = dynamicJSON.source?.json?.string,
			let _db = dynamicJSON.db?.json?.string,
			let _number = dynamicJSON.num?.json?.int
			else { return nil }
		
		self.init()
		self.id				= _id
		self.titlePersian	= _titlePersian
		self.titleEnglish	= _titleEnglish
		self.text			= _text
		self.source			= _source
		self.db				= _db
		self.number			= _number
	}
	
}

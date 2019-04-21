//
//  Word.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation
import RealmSwift

public final class Word: Object {
	
	public override static func primaryKey() -> String? {
		return "id"
	}
	
	public override static func ignoredProperties() -> [String] {
		return ["hasFullMeaning", "database", "isInMyWords"]
	}
	
	@objc dynamic public var id				: String	= ""
	@objc dynamic public var titlePersian	: String	= ""
	@objc dynamic public var titleEnglish	: String	= ""
	@objc dynamic public var db				: String	= ""
	@objc dynamic public var text			: String	= ""
	@objc dynamic public var source			: String	= ""
	@objc dynamic public var number			: Int		= 0
	
	@objc dynamic public var pronounce		: String	= ""
	@objc dynamic public var fullText		: String	= ""
	
	@objc dynamic public var hasFullMeaning	: Bool {
		return !fullText.isEmpty
	}
	
	@objc dynamic public var database		: Database {
		return V.RealmObject.object(ofType: Database.self, forPrimaryKey: db)!
	}
	
	@objc dynamic public var isInMyWords	: Bool {
		return V.RealmObject.object(ofType: Word.self, forPrimaryKey: id) != nil
	}
	
	private convenience init(copyOf word: Word) {
		self.init()
		self.id				= word.id
		self.titlePersian	= word.titlePersian
		self.titleEnglish	= word.titleEnglish
		self.db				= word.db
		self.text			= word.text
		self.source			= word.source
		self.number			= word.number
		self.pronounce		= word.pronounce
		self.fullText		= word.fullText
	}
	
	public convenience init?(from json: MiniAlamo.JSON) {
		let dynamicJSON = VDynamicJSON(from: json)
		
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
	
	public func setupMeaningDetails(from json: MiniAlamo.JSON) -> Bool {
		let dynamicJSON = VDynamicJSON(from: json)
		
		guard
			let _pronounce = dynamicJSON.word?.pron?.json?.string,
			let _fullText = dynamicJSON.word?.text?.json?.string
			else { return false }
		
		pronounce		= _pronounce
		fullText		= _fullText
		
		return true
	}
	
	public func toggleForMyWords(_ completionHandler: (Bool) -> Void) {
		if let word = V.RealmObject.object(ofType: Word.self, forPrimaryKey: id) {
			V.RealmObject.safeWrite {
				V.RealmObject.delete(word)
			}
			completionHandler(true)
		} else {
			let word = self.getCopy()
			V.RealmObject.safeWrite {
				V.RealmObject.add(word)
			}
			completionHandler(false)
		}
		
	}
	
	public func delete() {
		V.RealmObject.safeWrite {
			V.RealmObject.delete(self)
		}
	}
	
	private func getCopy() -> Word {
		return Word(copyOf: self)
	}
	
	@discardableResult
	public func getFullMeaning(_ completionHandler: @escaping (VError?) -> Void) -> MiniAlamo.DataRequest? {
		let endpoint = MiniAlamoEndpointObject(
			identifier		: nil,
			baseURLString	: V.ApiURL,
			path			: "word",
			method			: .get,
			encoding		: MiniAlamo.URLEncoding.queryString,
			parameters		: [
				"token"	: V.Token,
				"title"	: titlePersian,
				"db"	: db,
				"num"	: number
			],
			headers			: nil
		)
		
		return MiniAlamo.Perform(endpoint) { [weak self] (result, data) in
			guard let _self = self else { return }
			
			switch result {
			case .success:
				if	let data = data,
					_self.setupMeaningDetails(from: MiniAlamo.JSON(data)) {
					completionHandler(nil)
				} else {
					completionHandler(VError.withData(data))
				}
			case .requestCanceled:
				break
			default:
				completionHandler(VError.withData(data))
			}
			
		}
	}
	
}

extension Word {
	
	public static var MyWords: [Word] {
		var result: [Word] = []
		V.RealmObject.objects(Word.self).forEach { result.append($0) }
		return result
	}
	
}

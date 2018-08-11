//
//  V.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation

public struct V {
	
	public static var FrameworkBundle	= Foundation.Bundle(for: SearchManager.self)
	
	static private let UrlApi			: String = "http://api.vajehyab.com/v3/"
	static internal let Token			: String = "42173.bHFRgXvuP5pUYBd766I7nOIAevqv6PVhxB9NyFio"
	
	public static func StringFromPlist(bundle: Bundle = V.FrameworkBundle, file: String, named: String) -> String {
		let strings = NSDictionary(contentsOfFile: bundle.path(forResource: file, ofType: "plist")!)!
		return strings.object(forKey: named) as! String
	}
	
	public enum Colors: String {
		case Primary	= "#4527A0"
		case Secondary	= "#008BC8"
	}
	
	public struct Keys {
		static let UrlSearchWord	: String = UrlApi + "search"
		static let UrlSearchMeaning	: String = UrlApi + "word"
		static let UrlSuggest		: String = UrlApi + "suggest"
		
		struct Base {
			static let Token		: String = "token"
			static let IP			: String = "ip"
			static let Product		: String = "product"
		}
		
		static let KeyResponse		: String = "response"
		static let KeyMeta			: String = "meta"
		static let KeyData			: String = "data"
		static let KeyResult		: String = "results"
		static let KeySuggestion	: String = "suggestion"
		
		static let Query			: String = "q"
		static let Types			: String = "type"
		static let Start			: String = "start"
		static let Rows				: String = "rows"
		static let Filter			: String = "filter"
		static let Status			: String = "status"
		static let Code				: String = "code"
		static let Count			: String = "num_found"
		static let Id				: String = "id"
		static let TitlePersian		: String = "title"
		static let TitleEnglish		: String = "title_en"
		static let Text				: String = "text"
		static let Source			: String = "source"
		static let DB				: String = "db"
		static let Number			: String = "num"
		
		public enum ResultTypes: String {
			case Exact	= "exact"
			case Ava	= "ava"
			case Like	= "like"
			case Text	= "text"
			
			var Persian: String {
				return V.StringFromPlist(file: "Messages", named: "Request_Type_\(self.rawValue)")
			}
		}
		
		public enum Databases: String {
			static let All = [
				dehkhoda, moein, amid, motaradef, farhangestan, sareh, ganjvajeh, wiki, slang, quran,
				name, thesis, isfahani, bakhtiari, tehrani, dezfuli, gonabadi, mazani, en2Fa, ar2Fa,
				fa2En, fa2Ar
			]
			
			static let Common = [
				dehkhoda, moein, amid, motaradef, farhangestan, sareh, ganjvajeh, slang, quran, name, thesis
			]
			
			case dehkhoda, moein, amid, motaradef, farhangestan, sareh, ganjvajeh, wiki, slang, quran, name, thesis, isfahani, bakhtiari, tehrani, dezfuli, gonabadi, mazani, en2Fa, ar2Fa, fa2En, fa2Ar
			
			var Persian: String {
				switch self {
				case .dehkhoda		: return "لغت‌نامهٔ دهخدا"
				case .moein			: return "فرهنگ فارسی معین"
				case .amid			: return "فرهنگ فارسی عمید"
				case .motaradef		: return "واژگان مترادف و متضاد"
				case .farhangestan	: return "فرهنگ واژه‌های مصوّب فرهنگستان"
				case .sareh			: return "واژه‌های فارسی سره"
				case .ganjvajeh		: return "فرهنگ گنجواژه"
				case .slang			: return "اصطلاحات عامیانه"
				case .quran			: return "فرهنگ واژگان قرآن"
				case .name			: return "فرهنگ نام‌ها"
				case .thesis		: return "فرهنگ لغات علمی"
				default				: return ""
				}
			}
			
		}
	}
	
}

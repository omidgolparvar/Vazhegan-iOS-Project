//
//  Requester+APIRequests.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation
import Alamofire

extension Requester {
	
	public class func SearchWord(query: String, type: V.Keys.ResultTypes, start: Int = 0, rows: Int = 30, filter: [V.Keys.Databases],
						  then: @escaping (_ result: Requester.Result, _ data: AnyObject?) -> Void) -> Request? {
		
		let requestParams: [String: AnyObject] = [
			V.Keys.Base.Token: V.Token as AnyObject,
			V.Keys.Query: query as AnyObject,
			V.Keys.Types: type.rawValue as AnyObject,
			V.Keys.Start: 0 as AnyObject,
			V.Keys.Rows: rows as AnyObject,
			V.Keys.Filter: filter.map({ $0.rawValue.lowercased() }).joined(separator: ",") as AnyObject
		]
		return Do(method: .get, url: V.Keys.UrlSearchWord, encoding: URLEncoding.queryString, parameters: requestParams, hasAuthentication: false, then: then)
	}
	
	public class func GetMeaning(forWord word: Word,
						  then: @escaping (_ result: Requester.Result, _ data: AnyObject?) -> Void) {
		
		let requestParams: [String: AnyObject] = [
			V.Keys.Base.Token: V.Token as AnyObject,
			V.Keys.TitlePersian: word.titlePersian! as AnyObject,
			V.Keys.DB: word.db! as AnyObject,
			V.Keys.Number: word.number!
		]
		Do(method: .get, url: V.Keys.UrlSearchMeaning, encoding: JSONEncoding.default, parameters: requestParams, hasAuthentication: false, then: then)
	}
	
	public class func GetSuggest(query: String,
						  then: @escaping (_ result: Requester.Result, _ data: AnyObject?) -> Void) {
		
		let requestParams: [String: AnyObject] = [
			V.Keys.Base.Token: V.Token as AnyObject,
			V.Keys.Query: query as AnyObject
		]
		Do(method: .get, url: V.Keys.UrlSuggest, encoding: JSONEncoding.default, parameters: requestParams, hasAuthentication: false, then: then)
	}
	
}

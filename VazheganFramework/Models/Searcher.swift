//
//  Searcher.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 3/29/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation
import IDExt

public final class Searcher: NSObject {
	
	private typealias SearchStatuses		= (exact: SearchStatus, ava: SearchStatus, like: SearchStatus, text: SearchStatus)
	
	private weak var controller	: UIViewController!
	private weak var tableView	: UITableView!
	
	private var currentQuery	: String?
	private var currentStatuses	: SearchStatuses
	
	#warning("این بدرد می‌خوره تا داده‌های دریافتی رو پردازش کنم.")
	//let array = JSON(d)["data"]["result"].array
	
	public init(controller: UIViewController, tableView: UITableView) {
		self.controller			= controller
		self.tableView			= tableView
		
		self.currentQuery		= nil
		self.currentStatuses	= (.inactive, .inactive, .inactive, .inactive)
		
		super.init()
		
		setupTableView()
	}
	
	public func cancelSearch() {
		
	}
	
	private func setupTableView() {
		tableView.id_RemoveExtraSeparatorLines()
		tableView.id_SetDelegateAndDataSource(to: self)
		
		/*
		let frameworkBundle = V.FrameworkBundle
		tableView.register(UINib(nibName: "SearchResultTVH", bundle: frameworkBundle), forHeaderFooterViewReuseIdentifier: "SearchResultTVH")
		tableView.register(UINib(nibName: "SearchResultTVC", bundle: frameworkBundle), forCellReuseIdentifier: "SearchResultTVC")
		tableView.register(UINib(nibName: "SearchResultWithWordTVC", bundle: frameworkBundle), forCellReuseIdentifier: "SearchResultWithWordTVC")
		*/
	}
	
	
	public func searchWord(for text: String, type: ResultType) {
		#warning("براساس پایگاه داده‌های انتخابی کاربر، اون فیلد filter باید مقداردهی بشه.")
		
		let query = text.cleanedFromInvalidPersianCharacters
		let endpoint = IDMoyaEndpointObject(
			identifier		: nil,
			baseURLString	: V.ApiURL,
			path			: "search",
			method			: .get,
			encoding		: IDMoya.URLEncoding.queryString,
			parameters		: [
				"token"	: V.Token,
				"q"		: query,
				"type"	: type.rawValue,
				"start"	: 0,
				"rows"	: 30,
				"filter": ""
			],
			headers			: nil,
			useOAuth		: false
		)
		
		let request = IDMoya.Perform(endpoint) { (result, data) in
			
		}
		
		switch type {
		case .ava	: currentStatuses.ava	= .searching(dataRequest: request)
		case .exact	: currentStatuses.exact	= .searching(dataRequest: request)
		case .like	: currentStatuses.like	= .searching(dataRequest: request)
		case .text	: currentStatuses.text	= .searching(dataRequest: request)
		}
		
	}
	
	public func getMeaning(of word: Word) {
		let endpoint = IDMoyaEndpointObject(
			identifier		: nil,
			baseURLString	: V.ApiURL,
			path			: "word",
			method			: .get,
			encoding		: IDMoya.URLEncoding.queryString,
			parameters		: [
				"token"	: V.Token,
				"title"	: word.titlePersian,
				"db"	: word.db,
				"num"	: word.number
			],
			headers			: nil,
			useOAuth		: false
		)
		
		IDMoya.Perform(endpoint) { (result, data) in
			
		}
	}
	
	public func getSuggest(for query: String) {
		let endpoint = IDMoyaEndpointObject(
			identifier		: nil,
			baseURLString	: V.ApiURL,
			path			: "suggest",
			method			: .get,
			encoding		: IDMoya.URLEncoding.queryString,
			parameters		: [
				"token"	: V.Token,
				"q"		: query
			],
			headers			: nil,
			useOAuth		: false
		)
		
		IDMoya.Perform(endpoint) { (result, data) in
			
		}
	}
	
}

extension Searcher: UITableViewDataSource, UITableViewDelegate {
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 0
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
}

extension Searcher {
	
	public enum ResultType: String {
		case exact	= "exact"
		case ava	= "ava"
		case like	= "like"
		case text	= "text"
		
		var sectionNumber: Int {
			switch self {
			case .exact	: return 0
			case .ava	: return 1
			case .like	: return 2
			case .text	: return 3
			}
		}
		var persian: String {
			switch self {
			case .ava	: return "واژگان هم‌آوا"
			case .exact	: return "واژگان دقیق"
			case .like	: return "واژگان مشابه"
			case .text	: return "واژگان در معانی"
			}
		}
	}
	
	public enum SearchStatus {
		case inactive
		case searching(dataRequest: IDMoya.DataRequest?)
		case success(results: [Word])
		case failed(error: Error)
	}
		
}

//
//  SearchManager.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import PersianSwift

public protocol SearchManagerDelegate: NSObjectProtocol {
	func searchManagerDidStartSearching(for text: String)
	func searchManagerDidEndSearching(for section: Int)
	func searchManagerDidCancelSearching()
}

public final class SearchManager {
	
	public typealias SearchResultArrayItem = (type: V.Keys.ResultTypes, result: [Word], isWaiting: Bool, hasError: Bool, request: Request?)
	
	public weak var delegate	: SearchManagerDelegate? = nil
	
	public var searchResult		: [SearchResultArrayItem] = [
		(.Exact,	[],	false,	false,	nil),
		(.Ava,		[],	false,	false,	nil),
		(.Like,		[],	false,	false,	nil),
		(.Text,		[],	false,	false,	nil)
	]
	
	public var searchIsDone		: Bool = false
	
	public init(delegate: UITableViewController & SearchManagerDelegate) {
		self.delegate = delegate
		
		let delegateAsTableViewController = delegate as UITableViewController
		setupTableView(delegateAsTableViewController.tableView)
	}
	
	private func setupTableView(_ tableView: UITableView) {
		let frameworkBundle = V.FrameworkBundle
		tableView.register(UINib(nibName: "SearchResultTVH", bundle: frameworkBundle), forHeaderFooterViewReuseIdentifier: "SearchResultTVH")
		tableView.register(UINib(nibName: "SearchResultTVC", bundle: frameworkBundle), forCellReuseIdentifier: "SearchResultTVC")
		tableView.register(UINib(nibName: "SearchResultWithWordTVC", bundle: frameworkBundle), forCellReuseIdentifier: "SearchResultWithWordTVC")
	}
	
	public func numberOfSections() -> Int {
		return searchIsDone ? searchResult.count : 0
	}
	
	public func numberOfRows(in section: Int) -> Int {
		return searchResult[section].hasError ? 0 : searchResult[section].result.count
	}
	
	public func cellForRow(at indexPath: IndexPath, with tableView: UITableView) -> UITableViewCell {
		if searchResult[indexPath.section].type == .Exact {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTVC", for: indexPath) as! SearchResultTVC
			cell.setup(forWord: searchResult[indexPath.section].result[indexPath.row])
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultWithWordTVC", for: indexPath) as! SearchResultWithWordTVC
			cell.setup(forWord: searchResult[indexPath.section].result[indexPath.row])
			return cell
		}
	}
	
	private func removeAllResults() {
		for (index, _) in searchResult.enumerated() {
			searchResult[index].request?.cancel()
			searchResult[index].result.removeAll()
			searchResult[index].isWaiting = true
			searchResult[index].hasError = false
		}
	}
	
	public func cancelSearchAndRemoveResults() {
		removeAllResults()
		searchIsDone = false
		delegate?.searchManagerDidCancelSearching()
	}
	
	public func search(for text: String) {
		let query = text
			.replacingOccurrences(of: "ي", with: "ی")
			.replacingOccurrences(of: "ك", with: "ک")
			.replacingOccurrences(of: "ى", with: "ی")
		
		removeAllResults()
		searchIsDone = true
		
		delegate?.searchManagerDidStartSearching(for: text)
		
		for (index, item) in searchResult.enumerated() {
			searchResult[index].request = Requester.SearchWord(query: query, type: item.type, filter: V.Keys.Databases.Common) { [weak self] result, data in
				guard let _self = self else { return }
				
				_self.searchResult[index].isWaiting = false
				
				switch result {
				case .success:
					if	let d = data,
						let array = JSON(d)[V.Keys.KeyData][V.Keys.KeyResult].array {
						for word in array {
							let w = Word(fromJSON: word)
							_self.searchResult[index].result.append(w)
						}
						_self.delegate?.searchManagerDidEndSearching(for: index)
					} else {
						_self.searchResult[index].hasError = true
					}
				default:
					_self.searchResult[index].hasError = true
				}
				_self.delegate?.searchManagerDidEndSearching(for: index)
			}
		}
		
	}
	
}

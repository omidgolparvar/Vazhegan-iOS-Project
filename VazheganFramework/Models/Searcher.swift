//
//  Searcher.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 3/29/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

public protocol SearcherHeaderDelegate: NSObjectProtocol {
	func performSearch(text: String, type: Searcher.ResultType)
	func changeCollapseStatus(for section: Int)
}

public final class Searcher: NSObject {
	
	private typealias SearchStatuses = (exact: SearchStatus, ava: SearchStatus, like: SearchStatus, text: SearchStatus)
	
	private weak var controller	: UIViewController!
	private weak var tableView	: UITableView!
	
	private var currentQuery	: String?
	private var currentStatuses	: SearchStatuses?
	private var onTapRowClosure	: ((Word) -> Void)?
	
	public init(controller: UIViewController, tableView: UITableView) {
		self.controller			= controller
		self.tableView			= tableView
		
		self.currentQuery		= nil
		self.currentStatuses	= nil
		
		super.init()
		
		setupTableView()
	}
	
	private func setupTableView() {
		tableView.removeExtraSeparatorLines()
		tableView.setDelegateAndDataSource(to: self)
		
		let frameworkBundle = V.FrameworkBundle
		
		tableView.registerVCell(cellType: SearchResultCell.self, bundle: frameworkBundle)
		tableView.registerVCell(cellType: SearchResultWithWordCell.self, bundle: frameworkBundle)
		tableView.registerVCell(cellType: ErrorCell.self, bundle: frameworkBundle)
		tableView.registerVCell(cellType: SearchingCell.self, bundle: frameworkBundle)
		
		let headerNib = UINib(nibName: "SearchResultHeader", bundle: frameworkBundle)
		tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SearchResultHeader")
	}
	
	public func shouldPerformNewSearch(for text: String) -> Bool {
		let query = text.trimmed
		guard let currentQuery = self.currentQuery else { return true }
		return query != currentQuery
	}
	
	public func startSearch(for text: String) {
		guard shouldPerformNewSearch(for: text) else { return }
		cancelSearch()
		let query = text.trimmed
		currentStatuses = (
			.inactive(text: text, type: .exact),
			.inactive(text: text, type: .ava),
			.inactive(text: text, type: .like),
			.inactive(text: text, type: .text)
		)
		tableView.reloadData()
		
		if Settings.Shared.automaticRequestsInAllTypes {
			Searcher.ResultType.All.forEach {
				searchWord(for: query, type: $0)
			}
		} else {
			searchWord(for: query, type: .exact)
		}
	}
	
	public func cancelSearch() {
		guard let currentStatuses = currentStatuses else { return }
		let array = [currentStatuses.exact, currentStatuses.ava, currentStatuses.like, currentStatuses.text]
		for case let .searching(dataRequest) in array {
			dataRequest?.cancel()
		}
		self.currentQuery = nil
		self.currentStatuses = nil
		tableView.reloadData()
	}
	
	public func onTapRow(_ closure: @escaping (Word) -> Void) {
		onTapRowClosure = closure
	}
	
	private func searchWord(for text: String, type: ResultType) {
		guard let _ = currentStatuses else { return }
		
		let enabledDatabases = Database.All
			.filter { $0.isEnabled }
			.map { $0.identifier }
			.joined(separator: ",")
		
		let query = text.cleanedFromInvalidPersianCharacters
		let endpoint = MiniAlamoEndpointObject(
			identifier		: nil,
			baseURLString	: V.ApiURL,
			path			: "search",
			method			: .get,
			encoding		: MiniAlamo.URLEncoding.queryString,
			parameters		: [
				"token"	: V.Token,
				"q"		: query,
				"type"	: type.rawValue,
				"start"	: 0,
				"rows"	: 30,
				"filter": enabledDatabases
			],
			headers			: nil
		)
		
		let request = MiniAlamo.Perform(endpoint) { [weak self] (result, data) in
			guard let _self = self else { return }
			
			switch result {
			case .success:
				if	let data = data,
					let array = MiniAlamo.JSON(data)["data"]["results"].array {
					let words = array.compactMap({ Word(from: $0) })
					_self.setupCurrentStatuses(searchStatus: .success(results: words, isVisible: true), forResultType: type)
					_self.saveQueryToHistory(for: text)
				} else {
					let error = VError.requestWithInvalidResponse
					_self.setupCurrentStatuses(searchStatus: .failed(error: error, word: text, type: type), forResultType: type)
				}
			case .requestCanceled:
				break
			default:
				let error = VError.withData(data)
				_self.setupCurrentStatuses(searchStatus: .failed(error: error, word: text, type: type), forResultType: type)
			}
		}
		
		self.currentQuery = text
		self.tableView.removeBackgroundView()
		setupCurrentStatuses(searchStatus: .searching(dataRequest: request), forResultType: type)
	}
	
	private func getSuggest(for query: String) {
		let endpoint = MiniAlamoEndpointObject(
			identifier		: nil,
			baseURLString	: V.ApiURL,
			path			: "suggest",
			method			: .get,
			encoding		: MiniAlamo.URLEncoding.queryString,
			parameters		: [
				"token"	: V.Token,
				"q"		: query
			],
			headers			: nil
		)
		
		MiniAlamo.Perform(endpoint) { (result, data) in
			
		}
	}
	
	private func setupCurrentStatuses(searchStatus: SearchStatus, forResultType resultType: ResultType) {
		guard self.currentStatuses != nil else { return }
		
		switch resultType {
		case .ava	: currentStatuses!.ava		= searchStatus
		case .exact	: currentStatuses!.exact	= searchStatus
		case .like	: currentStatuses!.like		= searchStatus
		case .text	: currentStatuses!.text		= searchStatus
		}
		
		tableView.reloadSections([resultType.sectionNumber], with: .automatic)
	}
	
	private func getSearchStatus(forSection section: Int) -> SearchStatus? {
		guard let currentStatuses = currentStatuses else { return nil }
		switch section {
		case 0	: return currentStatuses.exact
		case 1	: return currentStatuses.ava
		case 2	: return currentStatuses.like
		case 3	: return currentStatuses.text
		default	: fatalError("Searcher - \(#function):: Wrong Section: \(section)")
		}
	}
	
	private func setSearchStatus(_ status: SearchStatus, forSection section: Int) {
		guard let currentStatuses = currentStatuses else { return }
		guard 0...3 ~= section else { return }
		self.currentStatuses = (
			section == 0 ? status : currentStatuses.exact,
			section == 1 ? status : currentStatuses.ava,
			section == 2 ? status : currentStatuses.like,
			section == 3 ? status : currentStatuses.text
		)
		tableView.reloadSections([section], with: .automatic)
	}
	
	private func getResultType(forSection section: Int) -> ResultType {
		switch section {
		case 0	: return .exact
		case 1	: return .ava
		case 2	: return .like
		case 3	: return .text
		default	: fatalError("Searcher - \(#function):: Wrong Section: \(section)")
		}
	}
	
	private func saveQueryToHistory(for text: String) {
		let query = Query(query: text)
		let predicate = NSPredicate.init(format: "query == %@", query.query)
		if let existingQuery = V.RealmObject.objects(Query.self).filter(predicate).first {
			existingQuery.setLastRequestDateToNow()
		} else {
			query.save()
		}
	}
	
}

extension Searcher: UITableViewDataSource, UITableViewDelegate {
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return currentStatuses == nil ? 0 : 4
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return getSearchStatus(forSection: section)?.numberOfRows ?? 0
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let _ = self.currentStatuses else {
			fatalError("Searcher - \(#function):: CurrentStatuses is Nil.")
		}
		let type = getSearchStatus(forSection: indexPath.section)!
		
		switch type {
		case .inactive:
			fatalError("Searcher - \(#function):: Wrong IndexPath.Row: \(indexPath.row)")
		case .failed(let error):
			let cell = tableView.dequeueReusableVCell(ErrorCell.self, for: indexPath)
			cell.setup(with: error.error) { [weak self] in
				guard let _self = self else { return }
				_self.searchWord(for: error.word, type: error.type)
			}
			return cell
		case .searching:
			let cell = tableView.dequeueReusableVCell(SearchingCell.self, for: indexPath)
			cell.setup()
			return cell
		case .success(let results, _):
			let type = getResultType(forSection: indexPath.section)
			switch type {
			case .exact:
				let cell = tableView.dequeueReusableVCell(SearchResultCell.self, for: indexPath)
				cell.setup(forWord: results[indexPath.row])
				return cell
			case .ava, .like, .text:
				let cell = tableView.dequeueReusableVCell(SearchResultWithWordCell.self, for: indexPath)
				cell.setup(forWord: results[indexPath.row])
				return cell

			}
		}
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 56.0
	}
	
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard
			let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchResultHeader") as? SearchResultHeader,
			let currentStatuses = currentStatuses
			else { return nil }
		
		var type: (ResultType, SearchStatus)
		switch section {
		case 0	: type = (.exact, currentStatuses.exact)
		case 1	: type = (.ava, currentStatuses.ava)
		case 2	: type = (.like, currentStatuses.like)
		case 3	: type = (.text, currentStatuses.text)
		default	: fatalError("Searcher - \(#function):: Wrong Section: \(section)")
		}
		
		header.setup(delegate: self, for: type, atSection: section)
		
		return header
	}
	
	public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		guard let _ = onTapRowClosure else { return }
		guard let type = getSearchStatus(forSection: indexPath.section) else { return }
		
		switch type {
		case .success:
			let cell = tableView.cellForRow(at: indexPath)
			UIView.animate(withDuration: 0.2) {
				cell?.backgroundColor = .Initialize(hexCode: "EFEFEF")
			}
		default:
			return
		}
	}
	
	public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		guard let _ = onTapRowClosure else { return }
		guard let type = getSearchStatus(forSection: indexPath.section) else { return }
		
		switch type {
		case .success:
			let cell = tableView.cellForRow(at: indexPath)
			UIView.animate(withDuration: 0.2) {
				cell?.backgroundColor = .white
			}
		default:
			return
		}
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let closure = onTapRowClosure else { return }
		guard let type = getSearchStatus(forSection: indexPath.section) else { return }
		
		switch type {
		case .success(let results, _):
			let word = results[indexPath.row]
			DispatchQueue.main.async {
				closure(word)
			}
		default:
			return
		}
	}
}

extension Searcher: SearcherHeaderDelegate {
	
	public func performSearch(text: String, type: Searcher.ResultType) {
		self.searchWord(for: text, type: type)
	}
	
	public func changeCollapseStatus(for section: Int) {
		guard let status = getSearchStatus(forSection: section) else { return }
		guard case let .success(results, isVisible) = status else { return }
		setSearchStatus(.success(results: results, isVisible: !isVisible), forSection: section)
	}
	
}

public extension Searcher {
	
	public enum ResultType: String {
		static let All: [ResultType] = [.exact, .ava, .like, .text]
		case exact	= "exact"
		case ava	= "ava"
		case like	= "like"
		case text	= "text"
		
		public var sectionNumber: Int {
			switch self {
			case .exact	: return 0
			case .ava	: return 1
			case .like	: return 2
			case .text	: return 3
			}
		}
		
		public var persian: String {
			switch self {
			case .ava	: return "واژگان هم‌آوا"
			case .exact	: return "واژگان دقیق"
			case .like	: return "واژگان مشابه"
			case .text	: return "واژگان در معانی"
			}
		}
	}
	
	public enum SearchStatus {
		case inactive(text: String, type: ResultType)
		case searching(dataRequest: MiniAlamo.DataRequest?)
		case success(results: [Word], isVisible: Bool)
		case failed(error: VError, word: String, type: ResultType)
		
		public var numberOfRows: Int {
			switch self {
			case .inactive:
				return 0
			case .searching,
				 .failed:
				return 1
			case .success(let results, let isVisible):
				return isVisible ? results.count : 0
			}
		}
	}
		
}

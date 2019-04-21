//
//  SearchResultTVH.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 2/26/17.
//  Copyright © 2017 Omid Golparvar. All rights reserved.
//

import UIKit
import PersianSwift

class SearchResultHeader: UITableViewHeaderFooterView {
	
	public static let Height		: CGFloat = 56.0
	
	@IBOutlet weak var labelTitle	: UILabel!
	@IBOutlet weak var labelDetail	: UILabel!
	@IBOutlet weak var buttonSearch	: UIButton!
	
	private weak var searcherDelegate	: SearcherHeaderDelegate!
	private var searchStatus			: Searcher.SearchStatus!
	
	func setup(delegate: SearcherHeaderDelegate, for type: (Searcher.ResultType, Searcher.SearchStatus)) {
		self.searcherDelegate = delegate
		self.searchStatus = type.1
		
		buttonSearch.roundCorners()
		labelTitle.text = type.0.persian
		switch type.1 {
		case .success(let results):
			labelDetail.text = "\(results.isEmpty ? "بدون" : results.count.ps.stringWithPersianDigits) نتیجه"
			buttonSearch.isHidden = true
		case .inactive:
			labelDetail.text = ""
			buttonSearch.isHidden = false
		case .failed:
			labelDetail.text = "بروز خطا"
			buttonSearch.isHidden = true
		case .searching:
			labelDetail.text = "در حال جستجو..."
			buttonSearch.isHidden = true
		}
	}
	
	@IBAction func action_PerformSearch(_ sender: UIButton) {
		guard case let .inactive(text, type)? = self.searchStatus else { return }
		searcherDelegate.performSearch(text: text, type: type)
	}

}

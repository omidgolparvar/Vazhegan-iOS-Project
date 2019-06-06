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
	private var section					: Int!
	
	func setup(delegate: SearcherHeaderDelegate, for type: (Searcher.ResultType, Searcher.SearchStatus), atSection section: Int) {
		self.searcherDelegate = delegate
		self.searchStatus = type.1
		self.section = section
		
		buttonSearch.roundCorners()
		labelTitle.text = type.0.persian
		switch type.1 {
		case .success(let results, let isVisible):
			labelDetail.text = "\(results.isEmpty ? "بدون" : results.count.ps.stringWithPersianDigits) نتیجه"
			buttonSearch.setTitle(isVisible ? "پنهان" : "نمایش", for: .normal)
			buttonSearch.isHidden = results.isEmpty
		case .inactive:
			labelDetail.text = ""
			buttonSearch.isHidden = false
			buttonSearch.setTitle("جستجو", for: .normal)
		case .failed:
			labelDetail.text = "بروز خطا"
			buttonSearch.isHidden = true
		case .searching:
			labelDetail.text = "در حال جستجو..."
			buttonSearch.isHidden = true
		}
	}
	
	@IBAction func action_PerformRelatedActionToSearchStatu(_ sender: UIButton) {
		switch self.searchStatus! {
		case .inactive(let text, let type):
			searcherDelegate.performSearch(text: text, type: type)
		case .success:
			searcherDelegate!.changeCollapseStatus(for: section)
		default:
			break
		}
	}

}

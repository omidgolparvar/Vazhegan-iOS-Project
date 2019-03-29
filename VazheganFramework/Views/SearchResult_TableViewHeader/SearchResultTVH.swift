//
//  SearchResultTVH.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 2/26/17.
//  Copyright © 2017 Omid Golparvar. All rights reserved.
//

import UIKit
import PersianSwift

public class SearchResultTVH: UITableViewHeaderFooterView {
	
	public static let Height		: CGFloat = 56.0
	
	@IBOutlet weak var labelTitle	: UILabel!
	@IBOutlet weak var labelDetail	: UILabel!
	
	public func setup() {
		/*
		labelTitle.text = searchResult.type.Persian
		if searchResult.isWaiting {
			labelDetail.text = V.StringFromPlist(file: "Messages", named: "Header_Waiting")
		} else if searchResult.hasError {
			labelDetail.text = V.StringFromPlist(file: "Messages", named: "Header_HasError")
		} else if searchResult.result.count == 0 {
			labelDetail.text = V.StringFromPlist(file: "Messages", named: "Header_NoResult")
		} else {
			labelDetail.text = String(format: V.StringFromPlist(file: "Messages", named: "Header_Result"), searchResult.result.count.ps.stringWithPersianDigits)
		}
		*/
	}

}

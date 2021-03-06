//
//  SearchResultWithWordTVC.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import UIKit

public class SearchResultWithWordCell: UITableViewCell {
	
	@IBOutlet weak var labelWord: UILabel!
	@IBOutlet weak var labelMeaning: UILabel!
	@IBOutlet weak var labelDatabase: UILabel!
	
	public override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	public func setup(forWord word: Word) {
		labelWord.text = word.titlePersian
		labelMeaning.text = word.text.ps.withPersianDigits
		labelDatabase.text = word.source
	}
	
}

extension SearchResultWithWordCell: VTableViewCell {
	
	public static var Identifier: String {
		return "SearchResultWithWordCell"
	}
	
}

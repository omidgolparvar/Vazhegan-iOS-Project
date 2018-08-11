//
//  SearchResultTVC.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import UIKit

public class SearchResultTVC: UITableViewCell {

	@IBOutlet weak var labelMeaning: UILabel!
	@IBOutlet weak var labelDatabase: UILabel!
	@IBOutlet weak var viewDatabaseHolder: UIView!
	
	override public func awakeFromNib() {
		super.awakeFromNib()
	}
	
	public func setup(forWord word: Word) {
		labelMeaning.text = word.text?.ps.withPersianDigits
		labelDatabase.text = word.source
	}
    
}

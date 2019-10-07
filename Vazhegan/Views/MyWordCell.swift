//
//  MyWordCell.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/20/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import VazheganFramework
import IDExt

class MyWordCell: UITableViewCell {
	
	@IBOutlet weak var label_Title				: UILabel!
	@IBOutlet weak var label_DatabaseName		: UILabel!
	@IBOutlet weak var view_DatabaseNameHolder	: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
		view_DatabaseNameHolder.setCornerRadius(view_DatabaseNameHolder.frame.height / 2.0)
    }
	
	func setup(with word: Word) {
		label_Title.text = word.titlePersian
		label_DatabaseName.text = word.database.name
	}
	
}

extension MyWordCell: IDTableViewCell {
	
	static var Identifier: String {
		return "MyWordCell"
	}
	
}

extension MyWordCell: IDHighlightableTableViewCell {
	
	public var highlightBackgroundColor: UIColor {
		return .ID_Initialize(hexCode: "EFEFEF")
	}
	
	public var originalBackgroundColor: UIColor {
		return .white
	}
	
	public var highlightViewTag: Int {
		return 1001
	}
	
}

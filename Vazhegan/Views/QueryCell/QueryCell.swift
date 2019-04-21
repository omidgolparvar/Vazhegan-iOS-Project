//
//  QueryCell.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/2/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt
import VazheganFramework

class QueryCell: UITableViewCell {
	
	@IBOutlet weak var label_QueryText	: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func setup(with query: Query) {
		label_QueryText.text = query.query
	}
}


extension QueryCell: IDTableViewCell {
	
	static var Identifier: String {
		return "QueryCell"
	}
	
	static var CellHeight: CGFloat {
		return 64.0
	}
	
}

extension QueryCell: IDHighlightableTableViewCell {
	
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

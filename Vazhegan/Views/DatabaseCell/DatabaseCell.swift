//
//  DatabaseCell.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/1/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt
import VazheganFramework

final class DatabaseCell: UITableViewCell {
	
	@IBOutlet weak var label_Icon			: UILabel!
	@IBOutlet weak var label_DatabaseTitle	: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		label_Icon.id_RoundCorners()
    }

	func setup(with database: Database) {
		label_Icon.backgroundColor = database.isEnabled ? .V : .white
		label_DatabaseTitle.text = database.name
	}
    
}

extension DatabaseCell: IDTableViewCell {
	
	static var Identifier: String {
		return "DatabaseCell"
	}
	
	static var CellHeight: CGFloat {
		return 64.0
	}
	
}

extension DatabaseCell: IDHighlightableTableViewCell {
	
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

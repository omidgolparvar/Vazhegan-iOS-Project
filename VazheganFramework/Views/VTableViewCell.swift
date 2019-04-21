//
//  VTableViewCell.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

public protocol VTableViewCell: class {
	
	static var Identifier	: String { get }
	
	static var CellHeight	: CGFloat { get }
	
}

public extension VTableViewCell {
	
	static var CellHeight: CGFloat {
		return UITableView.automaticDimension
	}
	
}

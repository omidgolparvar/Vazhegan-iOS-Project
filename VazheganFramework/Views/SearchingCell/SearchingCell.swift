//
//  SearchingCell.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 3/30/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

public class SearchingCell: UITableViewCell {
	
	@IBOutlet weak var activityIndicator	: UIActivityIndicatorView!
	
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	public func setup() {
		activityIndicator.startAnimating()
	}
	
}

extension SearchingCell: VTableViewCell {
	
	public static var Identifier: String {
		return "SearchingCell"
	}
	
}

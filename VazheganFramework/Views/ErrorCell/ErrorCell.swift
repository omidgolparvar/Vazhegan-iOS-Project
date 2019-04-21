//
//  ErrorCell.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 3/30/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

public class ErrorCell: UITableViewCell {
	
	@IBOutlet weak var label_ErrorMessage	: UILabel!
	@IBOutlet weak var button_Retry			: UIButton!
	
	private var retryHandler	: () -> Void	= { }
	
	override public func awakeFromNib() {
        super.awakeFromNib()
		button_Retry.roundCorners()
    }
	
	public func setup(with error: VError, retryHandler: @escaping () -> Void) {
		label_ErrorMessage.text = error.message
		self.retryHandler = retryHandler
		
	}
	
	@IBAction func action_Retry(_ sender: UIButton) {
		retryHandler()
	}
	
}

extension ErrorCell: VTableViewCell {
	
	public static var Identifier: String {
		return "ErrorCell"
	}
	
}

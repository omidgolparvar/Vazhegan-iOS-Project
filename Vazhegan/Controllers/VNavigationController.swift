//
//  VNavigationController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/1/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

class VNavigationController: UINavigationController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationBar.tintColor = .black
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
}

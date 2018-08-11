//
//  MessageBackgroundView.swift
//  PodPakhsh
//
//  Created by Omid Golparvar on 11/26/17.
//  Copyright © 2017 Omid Golparvar. All rights reserved.
//

import UIKit

class VazheganBackgroundView: UIView {
	
	@IBOutlet weak var buttonAction: UIButton!
	
	var view: UIView!
	weak var viewController: UIViewController?
	
	func xibSetup() {
		view = loadViewFromNib()
		view.frame = bounds
		view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
		addSubview(view)
		buttonAction.layer.cornerRadius = 16.0
		buttonAction.clipsToBounds = true
	}
	
	func loadViewFromNib() -> UIView {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: "VazheganBackgroundView", bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
		return view
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		xibSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		xibSetup()
	}
	
	func set(viewController: UIViewController) {
		self.viewController = viewController
	}
	
	@IBAction func actionHandler(_ sender: UIButton) {
		viewController?.performSegue(withIdentifier: "Segue_AboutController", sender: nil)
	}

}

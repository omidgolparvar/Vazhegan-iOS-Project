//
//  VazheganBackgroundView.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 3/29/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt

class VazheganBackgroundView: UIView {
	
	var view: UIView!
	
	@IBOutlet weak var button_Settings	: UIButton!
	@IBOutlet weak var button_About		: UIButton!
	@IBOutlet weak var button_MyWords	: UIButton!
	@IBOutlet weak var button_History	: UIButton!
	
	weak var viewController		: UIViewController!
	
	func xibSetup() {
		view = loadViewFromNib()
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(view)
		setupUI()
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
	
	private func setupUI() {
		button_Settings.id_SetCornerRadius(16)
		button_About.id_SetCornerRadius(16)
		button_MyWords.id_SetCornerRadius(16)
		button_History.id_SetCornerRadius(16)
	}
	
	func setup(viewController: UIViewController) {
		self.viewController = viewController
	}
	
	@IBAction func action_PresentSettingsController(_ sender: UIButton) {
		let settingsController = SettingsController.IDViewControllerInstance
		let navigationController = VNavigationController(rootViewController: settingsController)
		IDRouter.Present(
			source		: viewController,
			destination	: navigationController,
			type		: .storky(delegate: viewController as! IDStorkyPresenterDelegate)
		)
	}
	
	@IBAction func action_PresentAboutController(_ sender: UIButton) {
		let aboutController = AboutController.IDViewControllerInstance
		IDRouter.Present(
			source		: viewController,
			destination	: aboutController,
			type		: .storky(delegate: viewController as! IDStorkyPresenterDelegate)
		)
	}
	
	@IBAction func action_PresentMyWords(_ sender: UIButton) {
		let myWordsController = MyWordsController.IDViewControllerInstance
		let navigationController = VNavigationController(rootViewController: myWordsController)
		IDRouter.Present(
			source		: viewController,
			destination	: navigationController,
			type		: .storky(delegate: viewController as! IDStorkyPresenterDelegate)
		)
	}
	
	@IBAction func action_PresentHistory(_ sender: UIButton) {
		let historyController = HistoryController.IDViewControllerInstance
		historyController.searcherDelegate = (viewController as! HomeSearcherDelegate)
		let navigationController = VNavigationController(rootViewController: historyController)
		IDRouter.Present(
			source		: viewController,
			destination	: navigationController,
			type		: .storky(delegate: viewController as! IDStorkyPresenterDelegate)
		)
	}

}

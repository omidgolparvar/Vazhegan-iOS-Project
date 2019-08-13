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
	
	@IBOutlet weak var view_ButtonsHolder	: UIView!
	
	weak var viewController		: UIViewController!
	
	private func xibSetup() {
		view = loadViewFromNib()
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(view)
		setupUI()
	}
	
	private func loadViewFromNib() -> UIView {
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
		view_ButtonsHolder.id_SetCornerRadius(16)
	}
	
	func setup(viewController: UIViewController) {
		self.viewController = viewController
	}
	
	private func presentViewController(_ destination: UIViewController) {
		Haptic.impact(.medium).generate()
		IDRouter.Present(
			source		: viewController,
			destination	: destination,
			type		: .storky(delegate: viewController as! IDStorkyPresenterDelegate)
		)
	}
	
	@IBAction func action_PresentSettingsController(_ sender: UIButton) {
		let settingsController = SettingsController.IDViewControllerInstance
		let navigationController = VNavigationController(rootViewController: settingsController)
		presentViewController(navigationController)
	}
	
	@IBAction func action_PresentAboutController(_ sender: UIButton) {
		let aboutController = AboutController.IDViewControllerInstance
		presentViewController(aboutController)
	}
	
	@IBAction func action_PresentMyWords(_ sender: UIButton) {
		let myWordsController = MyWordsController.IDViewControllerInstance
		let navigationController = VNavigationController(rootViewController: myWordsController)
		presentViewController(navigationController)
	}
	
	@IBAction func action_PresentHistory(_ sender: UIButton) {
		let historyController = HistoryController.IDViewControllerInstance
		historyController.searcherDelegate = (viewController as! HomeSearcherDelegate)
		let navigationController = VNavigationController(rootViewController: historyController)
		presentViewController(navigationController)
	}

}

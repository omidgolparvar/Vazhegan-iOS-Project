//
//  HomeController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 3/29/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt
import VazheganFramework

protocol HomeSearcherDelegate: NSObjectProtocol {
	func repeatSearch(for query: Query)
}

final class HomeController: UIViewController {
	
	@IBOutlet weak var view_Header				: UIView!
	@IBOutlet weak var view_TextFieldHolder		: UIView!
	@IBOutlet weak var textField_SearchBox		: UITextField!
	@IBOutlet weak var view_Line				: UIView!
	@IBOutlet weak var tableView_Results		: UITableView!
	@IBOutlet weak var button_ClearTextField	: UIButton!
	@IBOutlet weak var view_ButtonsHolder		: UIView!
	
	private var searcher	: Searcher!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupModels()
	}
	
	@IBAction func action_TextFieldSearchBox_EditingChanged(_ sender: UITextField) {
		let text = textField_SearchBox.text?.id_Trimmed ?? ""
		textField_SearchBox.text = text
		button_ClearTextField.isHidden = text.isEmpty
	}
	
	@IBAction func action_ButtonClearSearchBox_Tapped(_ sender: UIButton) {
		self.id_EndEditing()
		button_ClearTextField.isHidden = true
		textField_SearchBox.text = ""
		searcher.cancelSearch()
		setupViews_VazheganBackgroundView()
		setupViews_ToolbarVisibility(isVisible: true)
	}
	
	@IBAction func action_ButtonSettings_Tapped(_ sender: UIButton) {
		let settingsController = SettingsController.IDViewControllerInstance
		let navigationController = VNavigationController(rootViewController: settingsController)
		presentViewController(navigationController)
	}
	
	@IBAction func action_ButtonMyWords_Tapped(_ sender: UIButton) {
		let myWordsController = MyWordsController.IDViewControllerInstance
		let navigationController = VNavigationController(rootViewController: myWordsController)
		presentViewController(navigationController)
	}
	
	@IBAction func action_ButtonHistory_Tapped(_ sender: UIButton) {
		let historyController = HistoryController.IDViewControllerInstance
		historyController.searcherDelegate = (self as HomeSearcherDelegate)
		let navigationController = VNavigationController(rootViewController: historyController)
		presentViewController(navigationController)
	}
	
	
}

extension HomeController: IDStoryboardInstanceProtocol {
	
}

extension HomeController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		guard let text = textField.text?.id_Trimmed, !text.isEmpty else { return true }
		searcher!.startSearch(for: text)
		setupViews_ToolbarVisibility(isVisible: false)
		return true
	}
}

extension HomeController: IDStorkyPresenterDelegate {
	
	func idStorkyPresenter_ShowIndicator(for controller: UIViewController) -> Bool {
		return false
	}
	
	func idStorkyPresenter_IsSwipeToDismissEnabled(for controller: UIViewController) -> Bool {
		return false
	}
}

extension HomeController: HomeSearcherDelegate {
	
	func repeatSearch(for query: Query) {
		textField_SearchBox.text = query.query
		button_ClearTextField.isHidden = false
		searcher.startSearch(for: query.query)
		setupViews_ToolbarVisibility(isVisible: false)
	}
	
}

extension HomeController {
	
	private func setupViews() {
		button_ClearTextField.isHidden = true
		view_TextFieldHolder.id_RoundCorners()
		textField_SearchBox.delegate = self
		setupViews_VazheganBackgroundView()
		setupViews_EntranceView()
		setupViews_Toolbar()
		//setupViews_ForiOS13()
	}
	
	private func setupViews_VazheganBackgroundView() {
		let tableViewFrame = tableView_Results.frame
		let bgView = VazheganBackgroundView(frame: CGRect(x: 0, y: 0, width: tableViewFrame.width, height: tableViewFrame.height))
		tableView_Results.backgroundView = bgView
	}
	
	private func setupViews_EntranceView() {
		let coverView = UIView(frame: .zero)
		view.addSubview(coverView)
		
		coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		coverView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		coverView.translatesAutoresizingMaskIntoConstraints = false
		coverView.backgroundColor = .V
		
		let vImageView = UIImageView(image: #imageLiteral(resourceName: "Launchy"))
		coverView.addSubview(vImageView)
		
		vImageView.translatesAutoresizingMaskIntoConstraints = false
		vImageView.centerXAnchor.constraint(equalTo: coverView.centerXAnchor).isActive = true
		vImageView.centerYAnchor.constraint(equalTo: coverView.centerYAnchor).isActive = true
		vImageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
		vImageView.heightAnchor.constraint(equalToConstant: 128).isActive = true
		
		view.bringSubviewToFront(coverView)
		
		UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseInOut], animations: {
			coverView.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
			coverView.alpha = 0.0
		}) { (_) in
			coverView.removeFromSuperview()
		}
	}
	
	private func setupViews_Toolbar() {
		view_ButtonsHolder.layer.cornerRadius = view_ButtonsHolder.frame.height / 2.0
		view_ButtonsHolder.layer.shadowColor = UIColor.black.cgColor
		view_ButtonsHolder.layer.shadowOffset = CGSize(width: 0, height: -4)
		view_ButtonsHolder.layer.shadowRadius = 16.0
		view_ButtonsHolder.layer.shadowOpacity = 0.3
	}
	
	private func setupViews_ToolbarVisibility(isVisible: Bool) {
		if isVisible {
			view_ButtonsHolder.alpha = 0.0
			view_ButtonsHolder.isHidden = false
			UIView.animate(
				withDuration: 0.6,
				delay: 0.0,
				usingSpringWithDamping: 1.0,
				initialSpringVelocity: 1.0,
				options: [],
				animations: {
					self.view_ButtonsHolder.transform = .identity
					self.view_ButtonsHolder.alpha = 1.0
				},
				completion: nil
			)
		} else {
			UIView.animate(
				withDuration: 0.6,
				delay: 0.0,
				usingSpringWithDamping: 1.0,
				initialSpringVelocity: 1.0,
				options: [],
				animations: {
					self.view_ButtonsHolder.transform = CGAffineTransform.init(translationX: 0, y: 32)
					self.view_ButtonsHolder.alpha = 0.0
				},
				completion: { _ in
					self.view_ButtonsHolder.isHidden = true
				}
			)
		}
	}
	
	private func setupViews_ForiOS13() {
		guard #available(iOS 13.0, *) else { return }
		guard let keyWindow = UIApplication.shared.keyWindow else { return }
		
		keyWindow.isOpaque = false
		keyWindow.backgroundColor = .clear
		
		view.isOpaque = false
		view.backgroundColor = .clear
		
		let backgroundBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		backgroundBlurView.frame = view.bounds
		backgroundBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		tableView_Results.backgroundView?.backgroundColor = .clear
		
		view.addSubview(backgroundBlurView)
		view.sendSubviewToBack(backgroundBlurView)
	}
	
	private func setupModels() {
		self.searcher = Searcher(controller: self, tableView: tableView_Results)
		self.searcher!.onTapRow { [weak self] (word) in
			guard let _self = self else { return }
			
			let wordController = WordController.IDViewControllerInstance
			wordController.word = word
			
			IDRouter.Present(
				source		: _self,
				destination	: wordController,
				type		: .storky(delegate: _self)
			)
		}
		
	}
	
	private func presentViewController(_ destination: UIViewController) {
		Haptic.impact(.medium).generate()
		IDRouter.Present(
			source		: self,
			destination	: destination,
			type		: .storky(delegate: self as IDStorkyPresenterDelegate)
		)
	}
	
}

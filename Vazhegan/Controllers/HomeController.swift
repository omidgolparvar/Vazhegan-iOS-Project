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
	}
	
	
}

extension HomeController: IDStoryboardInstanceProtocol {
	
}

extension HomeController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		guard let text = textField.text?.id_Trimmed, !text.isEmpty else { return true }
		searcher!.startSearch(for: text)
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
	}
	
}

extension HomeController {
	
	private func setupViews() {
		button_ClearTextField.isHidden = true
		view_TextFieldHolder.id_RoundCorners()
		textField_SearchBox.delegate = self
		setupViews_VazheganBackgroundView()
	}
	
	private func setupViews_VazheganBackgroundView() {
		let tableViewFrame = tableView_Results.frame
		let bgView = VazheganBackgroundView(frame: CGRect(x: 0, y: 0, width: tableViewFrame.width, height: tableViewFrame.height))
		bgView.setup(viewController: self)
		tableView_Results.backgroundView = bgView
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
	
}

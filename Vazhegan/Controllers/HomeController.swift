//
//  HomeController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 3/29/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt

final class HomeController: UIViewController {
	
	@IBOutlet weak var view_Header				: UIView!
	@IBOutlet weak var view_TextFieldHolder		: UIView!
	@IBOutlet weak var textField_SearchBox		: UITextField!
	@IBOutlet weak var view_Line				: UIView!
	@IBOutlet weak var tableView_Results		: UITableView!
	@IBOutlet weak var button_ClearTextField	: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
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
	}
	
	private func setupViews() {
		button_ClearTextField.isHidden = true
		setupViews_TextFieldSearchBox()
		setupViews_TableViewResults()
		setupViews_VazheganBackgroundView(animated: false)
	}
	
	private func setupViews_TextFieldSearchBox() {
		view_TextFieldHolder.id_RoundCorners()
	}
	
	private func setupViews_TableViewResults() {
		tableView_Results.id_RemoveExtraSeparatorLines()
	}
	
	private func setupViews_VazheganBackgroundView(animated: Bool) {
		let tableViewFrame = tableView_Results.frame
		let bgView = VazheganBackgroundView(frame: CGRect(x: 0, y: 0, width: tableViewFrame.width, height: tableViewFrame.height))
		bgView.setup(viewController: self)
		if animated {
			UIView.transition(with: tableView_Results, duration: 0.2, options: [], animations: {
				self.tableView_Results.backgroundView = bgView
			}, completion: nil)
		} else {
			tableView_Results.backgroundView = bgView
		}
	}
	
}

extension HomeController: IDStoryboardInstanceProtocol {
	
}

extension HomeController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		#warning("باید سرچ رو انجام بدم")
		textField.resignFirstResponder()
		return true
	}
}

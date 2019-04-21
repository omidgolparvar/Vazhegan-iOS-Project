//
//  HomeController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 3/29/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import VazheganFramework
import MobileCoreServices

final class HomeController: UIViewController {
	
	deinit {
		searcher.cancelSearch()
	}
	
	@IBOutlet weak var view_Header				: UIView!
	@IBOutlet weak var view_TextFieldHolder		: UIView!
	@IBOutlet weak var textField_SearchBox		: UITextField!
	@IBOutlet weak var view_Line				: UIView!
	@IBOutlet weak var tableView_Results		: UITableView!
	@IBOutlet weak var button_ClearTextField	: UIButton!
	@IBOutlet weak var button_Dismiss			: UIButton!
	
	private var searcher	: Searcher!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupModels()
		getInputTextFromContext()
	}
	
	@IBAction func action_TextFieldSearchBox_EditingChanged(_ sender: UITextField) {
		let text = textField_SearchBox.text?.trimmed ?? ""
		textField_SearchBox.text = text
		button_ClearTextField.isHidden = text.isEmpty
	}
	
	@IBAction func action_ButtonClearSearchBox_Tapped(_ sender: UIButton) {
		self.view.endEditing(true)
		button_ClearTextField.isHidden = true
		textField_SearchBox.text = ""
		searcher.cancelSearch()
	}
	
	@IBAction func action_ButtonDismiss_Tapped(_ sender: UIButton) {
		extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
		dismiss(animated: true, completion: nil)
	}
	
	
}

extension HomeController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		guard let text = textField.text?.trimmed, !text.isEmpty else { return true }
		searcher!.startSearch(for: text)
		return true
	}
	
}

extension HomeController {
	
	private func setupViews() {
		button_Dismiss.roundCorners()
		button_ClearTextField.isHidden = true
		view_TextFieldHolder.roundCorners()
		textField_SearchBox.delegate = self
	}
	
	private func setupModels() {
		self.searcher = Searcher(controller: self, tableView: tableView_Results)
	}
	
	private func getInputTextFromContext() {
		guard
			let inputItems = self.extensionContext?.inputItems, !inputItems.isEmpty,
			let textItem = inputItems[0] as? NSExtensionItem,
			let attachments = textItem.attachments, !attachments.isEmpty,
			let textItemProvider = textItem.attachments?[0],
			textItemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String)
			else { return }
		
		textItemProvider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) {
			[weak self] (item, error) in
			
			DispatchQueue.main.async { [weak self] in
				self?.handleContextProviderResult(item: item, error: error)
			}
		}
		
	}
	
	private func handleContextProviderResult(item: NSSecureCoding?, error: Error?) {
		guard error == nil else {
			setupErrorLabel(for: error!.localizedDescription)
			return
		}
		
		guard let string = item as? String else {
			setupErrorLabel(for: "متن در دسترس نمی‌باشد")
			return
		}
		
		textField_SearchBox.text = string
		searcher!.startSearch(for: string)
	}
	
	private func setupErrorLabel(for message: String) {
		let tableViewFrame = tableView_Results.frame
		let label = UILabel(frame: .init(x: 0, y: 0, width: tableViewFrame.width, height: tableViewFrame.height))
		label.font = UIFont(name: "IRANSansMobile", size: 16.0)!
		label.textColor = .red
		label.text = "بروز خطا" + "\n\n" + message
		label.textAlignment = .center
		tableView_Results.backgroundView = label
	}
	
}

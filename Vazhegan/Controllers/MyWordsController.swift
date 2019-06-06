//
//  MyWordsController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/20/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import VazheganFramework
import IDExt
import IDAlert

final class MyWordsController: UITableViewController {
	
	private var myWords: [Word] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		setupDatasource()
    }
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWords.count
    }
	
	override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.id_ModifyBackgroundColor(isHighlighted: true)
	}
	
	override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.id_ModifyBackgroundColor(isHighlighted: false)
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.id_DequeueReusableIDCell(MyWordCell.self, for: indexPath)
		cell.setup(with: myWords[indexPath.row])
		return cell
    }
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .normal, title: "❌") { (action, indexPath) in
			let action_Delete = IDAlertAction.InitializeNormalAction(title: "حذف", actionStyle: .destructive) { [unowned self] in
				self.deleteWord(at: indexPath)
			}
			let action_Cancel = IDAlertAction.InitializeNormalAction(title: "بازگشت", actionStyle: .cancel, handler: nil)
			let alertHeader = IDAlertHeader(title: nil, message: "اطمینان دارین که می‌خواین این کلمه حذف بشه؟")
			let idAlertController = IDAlertController(header: alertHeader, actions: [action_Delete, action_Cancel], preferredStyle: .alert)
			self.present(idAlertController, animated: true, completion: nil)
		}
		delete.backgroundColor = #colorLiteral(red: 0.9601849914, green: 0.9601849914, blue: 0.9601849914, alpha: 1)
		
		return [delete]
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		0.0.id_AfterSecondsPerform { [unowned self] in
			let wordController = WordController.IDViewControllerInstance
			wordController.word = self.myWords[indexPath.row]
			wordController.shouldViewAddToMyWordsButton = false
			
			IDRouter.Present(
				source		: self,
				destination	: wordController,
				type		: .storky(delegate: self)
			)
		}
	}
	
	@IBAction func action_Dismiss(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
}

extension MyWordsController: IDStoryboardInstanceProtocol {
	
}

extension MyWordsController: IDStorkyPresenterDelegate {
	
	func idStorkyPresenter_ShowIndicator(for controller: UIViewController) -> Bool {
		return false
	}
	
	func idStorkyPresenter_IsSwipeToDismissEnabled(for controller: UIViewController) -> Bool {
		return true
	}
}

extension MyWordsController {
	
	private func setupViews() {
		tableView.id_RemoveExtraSeparatorLines()
		tableView.id_RegisterIDCell(cellType: MyWordCell.self)
	}
	
	private func setupDatasource() {
		let words = Word.MyWords
		if words.isEmpty {
			setupViews_ForEmptyList()
		} else {
			myWords = words
			tableView.reloadData()
		}
	}
	
	private func setupViews_ForEmptyList() {
		let tableViewFrame = tableView.frame
		let messageView = IDMessageBackgroundView(frame: .init(x: 0, y: 0, width: tableViewFrame.width, height: tableViewFrame.height))
			.setEmoji("👀")
			.setTexts(title: "خالی می‌باشه", message: "هیچ کلمه‌ای رو وارد لیست کلمات نکردین!")
		tableView.backgroundView = messageView
	}
	
	private func deleteWord(at indexPath: IndexPath) {
		let word = myWords[indexPath.row]
		word.delete()
		myWords.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .automatic)
		
		if myWords.isEmpty {
			setupViews_ForEmptyList()
		}
	}
}

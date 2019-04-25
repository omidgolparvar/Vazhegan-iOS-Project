//
//  HistoryController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/2/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt
import VazheganFramework

final class HistoryController: UITableViewController {
	
	private var allQueries: [Query] = []
	
	weak var searcherDelegate: HomeSearcherDelegate!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		setupDatasource()
    }
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allQueries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.id_DequeueReusableIDCell(QueryCell.self, for: indexPath)
		cell.setup(with: allQueries[indexPath.row])
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.id_ModifyBackgroundColor(isHighlighted: true)
	}
	
	override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.id_ModifyBackgroundColor(isHighlighted: false)
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "❌") { [unowned self] (action, indexPath) in
			self.deleteQuery(at: indexPath)
		}
		delete.backgroundColor = #colorLiteral(red: 0.9601849914, green: 0.9601849914, blue: 0.9601849914, alpha: 1)
		
		return [delete]
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		0.0.id_AfterSecondsPerform { [unowned self] in
			let delegate = self.searcherDelegate
			let query = self.allQueries[indexPath.row]
			self.dismiss(animated: true, completion: {
				delegate?.repeatSearch(for: query)
			})
		}
	}
	
	@IBAction func action_Dismiss(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
}

extension HistoryController: IDStoryboardInstanceProtocol {
	
}

extension HistoryController {
	
	private func setupViews() {
		tableView.id_RemoveExtraSeparatorLines()
		tableView.id_RegisterIDCell(cellType: QueryCell.self)
		tableView.id_SetHeights(rowHeight: QueryCell.CellHeight, estimatedRowHeight: QueryCell.CellHeight)
		if allQueries.isEmpty {
			navigationItem.rightBarButtonItem = nil
		}
	}
	
	private func setupViews_ForEmptyList() {
		let tableViewFrame = tableView.frame
		let messageView = IDMessageBackgroundView(frame: .init(x: 0, y: 0, width: tableViewFrame.width, height: tableViewFrame.height))
			.setEmoji("👀")
			.setTexts(title: "خالی می‌باشه", message: "هیچ کلمه‌ای رو جستجو نکردین!")
		tableView.backgroundView = messageView
	}
	
	private func setupDatasource() {
		let queries = Query.All
		if queries.isEmpty {
			setupViews_ForEmptyList()
		} else {
			allQueries = queries
			tableView.reloadData()
		}
	}
	
	private func deleteQuery(at indexPath: IndexPath) {
		let query = allQueries[indexPath.row]
		query.delete()
		allQueries.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .automatic)
		
		if allQueries.isEmpty {
			setupViews_ForEmptyList()
		}
	}
	
}

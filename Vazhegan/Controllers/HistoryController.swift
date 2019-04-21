//
//  HistoryController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/2/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt
import Sheety
import VazheganFramework

final class HistoryController: UITableViewController {
	
	private var allQueries: [Query] = {
		return Query.All
	}()
	
	weak var searcherDelegate: HomeSearcherDelegate!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
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
	
	@IBAction func action_ShowDeleteOptions(_ sender: UIBarButtonItem) {
		let action_DeleteAll = SheetyAction.init(title: .init(text: "حذف همه", font: IDFont.Medium.withSize(18), textColor: .red)) { [unowned self] in
			Query.DeleteAll()
			self.allQueries = []
			self.tableView.reloadSections([0], with: .automatic)
			self.navigationItem.rightBarButtonItem = nil
		}
		self.presentSheetyActionController(with: [action_DeleteAll])
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
	
}

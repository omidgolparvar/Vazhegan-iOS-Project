//
//  DatabasesController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/1/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import VazheganFramework
import IDExt

class DatabasesController: UITableViewController {
	
	private var allDatabases: [Database] = {
		let databases = Database.All.sorted(by: { (d1, _) in
			return d1.isEnabled
		})
		return databases
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDatabases.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.id_DequeueReusableIDCell(DatabaseCell.self, for: indexPath)
		cell.setup(with: allDatabases[indexPath.row])
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
			self.allDatabases[indexPath.row].toggleIsEnable()
			self.tableView.reloadRows(at: [indexPath], with: .none)
		}
	}
	
}

extension DatabasesController {
	
	private func setupViews() {
		tableView.id_RemoveExtraSeparatorLines()
		tableView.id_RegisterIDCell(cellType: DatabaseCell.self)
		tableView.id_SetHeights(rowHeight: DatabaseCell.CellHeight, estimatedRowHeight: DatabaseCell.CellHeight)
	}
	
}

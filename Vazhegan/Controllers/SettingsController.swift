//
//  SettingsController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 3/31/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt
import VazheganFramework

final class SettingsController: UITableViewController {
	
	@IBOutlet weak var switch_AutomaticRequestsInAllTypes	: UISwitch!
	
	private let sharedSettings			= Settings.Shared
	private let highlightableCellRows	= [0]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		guard highlightableCellRows.contains(indexPath.row) else { return }
		let cell = tableView.cellForRow(at: indexPath)
		UIView.animate(withDuration: 0.2) {
			cell?.backgroundColor = .ID_Initialize(hexCode: "EFEFEF")
		}
	}
	
	override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		UIView.animate(withDuration: 0.2) {
			cell?.backgroundColor = .white
		}
	}
	
	@IBAction func action_Dismiss(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func action_ChangeAutomaticRequestsInAllTypes(_ sender: UISwitch) {
		sharedSettings.set(automaticRequestsInAllTypes: switch_AutomaticRequestsInAllTypes.isOn)
	}
	
}

extension SettingsController: IDStoryboardInstanceProtocol {
	
}

extension SettingsController {
	
	private func setupViews() {
		tableView.id_RemoveExtraSeparatorLines()
		
		setupViews_BasedOnSettings()
	}
	
	private func setupViews_BasedOnSettings() {
		switch_AutomaticRequestsInAllTypes.isOn = sharedSettings.automaticRequestsInAllTypes
	}
}

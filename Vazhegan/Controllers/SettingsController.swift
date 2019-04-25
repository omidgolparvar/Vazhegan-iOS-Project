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
	@IBOutlet weak var label_AppVersion						: UILabel!
	
	private let sharedSettings			= Settings.Shared
	private let highlightableCellRows	= [0, 3, 4]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 3	: DispatchQueue.main.async { [unowned self] in self.action_ContactUs() }
		case 4	: DispatchQueue.main.async { [unowned self] in self.action_ShareApp() }
		default	: break
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
import Sheety
extension SettingsController {
	
	private func setupViews() {
		setupViews_BasedOnSettings()
	}
	
	private func setupViews_BasedOnSettings() {
		switch_AutomaticRequestsInAllTypes.isOn = sharedSettings.automaticRequestsInAllTypes
		label_AppVersion.text = sharedSettings.applicationVersion
	}
	
	private func action_ContactUs() {
		let action_Telegram = SheetyAction(title: .init(text: "تلگرام")) {
			UIApplication.ID_TryToOpen(url: URL(string: "tg://resolve?domain=golparvar")!, onFailed: {
				UIApplication.ID_Open(url: URL(string: "https://telegram.me/golparvar")!)
			})
		}
		
		let action_Instagram = SheetyAction(title: .init(text: "اینستاگرام")) {
			UIApplication.ID_TryToOpen(url: URL(string: "instagram://user?username=golparvar")!, onFailed: {
				UIApplication.ID_Open(url: URL(string: "https://www.instagram.com/golparvar/")!)
			})
		}
		
		presentSheetyActionController(with: [action_Telegram, action_Instagram])
	}
	
	private func action_ShareApp() {
		let text = "📱 واژگان" + "\n" + V.AppDownloadLink
		id_PresentActivityController(forItems: [text], customActivities: nil, sourceView: tableView)
	}
	
}

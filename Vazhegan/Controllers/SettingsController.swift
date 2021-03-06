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
import IDAlert

final class SettingsController: UITableViewController {
	
	@IBOutlet weak var switch_AutomaticRequestsInAllTypes	: UISwitch!
	@IBOutlet weak var label_AppVersion						: UILabel!
	
	private let sharedSettings			= Settings.Shared
	private let highlightableCellRows	= [0, 3, 4, 5]
	
	private let row_AboutApp	= 3
	private let row_ContactUs	= 4
	private let row_ShareApp	= 5
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
		case row_AboutApp	: DispatchQueue.main.async { [unowned self] in self.action_AboutApp() }
		case row_ContactUs	: DispatchQueue.main.async { [unowned self] in self.action_ContactUs() }
		case row_ShareApp	: DispatchQueue.main.async { [unowned self] in self.action_ShareApp() }
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

extension SettingsController: IDStorkyPresenterDelegate {
	
	func idStorkyPresenter_ShowIndicator(for controller: UIViewController) -> Bool {
		return false
	}
	
	func idStorkyPresenter_IsSwipeToDismissEnabled(for controller: UIViewController) -> Bool {
		return false
	}
	
}

extension SettingsController {
	
	private func setupViews() {
		setupViews_BasedOnSettings()
	}
	
	private func setupViews_BasedOnSettings() {
		switch_AutomaticRequestsInAllTypes.isOn = sharedSettings.automaticRequestsInAllTypes
		label_AppVersion.text = sharedSettings.applicationVersion
	}
	
	private func action_ContactUs() {
		let idAlertHeader = IDAlertHeader(title: "ارتباط با من یا تیم‌مون", message: "از طریق گزینه‌های زیر می‌تونین با من یا تیم‌مون ارتباط داشته باشین")
		
		let action_Telegram = IDAlertAction.InitializeNormalAction(title: "تلگرام خودم", alignment: .right, leftImage: #imageLiteral(resourceName: "App_Telegram")) {
			UIApplication.ID_TryToOpen(url: URL(string: "tg://resolve?domain=golparvar")!, onFailed: {
				UIApplication.ID_Open(url: URL(string: "https://telegram.me/golparvar")!)
			})
		}
		
		let action_Website = IDAlertAction.InitializeNormalAction(title: "وبسایت تیم‌مون", alignment: .right, leftImage: #imageLiteral(resourceName: "App_Safari")) {
			UIApplication.ID_Open(url: URL(string: "https://www.idco.io/")!)
		}
		
		let action_Cancel = IDAlertAction.InitializeNormalAction(title: "بازگشت", actionStyle: .cancel, handler: nil)
		
		let idAlertController = IDAlertController(
			header			: idAlertHeader,
			actions			: [action_Telegram, action_Website, action_Cancel],
			preferredStyle	: .actionSheet
		)
		
		self.present(idAlertController, animated: true, completion: nil)
	}
	
	private func action_ShareApp() {
		let text = "📱 واژگان" + "\n" + V.AppDownloadLink
		let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view
		activityViewController.popoverPresentationController?.sourceRect = self.view.bounds
		activityViewController.popoverPresentationController?.permittedArrowDirections = []
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	private func action_AboutApp() {
		let aboutController = AboutController.IDViewControllerInstance
		IDRouter.Present(
			source		: self,
			destination	: aboutController,
			type		: .storky(delegate: self)
		)
	}
}

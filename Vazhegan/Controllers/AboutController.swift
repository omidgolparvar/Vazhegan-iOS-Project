//
//  AboutController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import IDExt

final class AboutController: UITableViewController {
	
	@IBOutlet weak var button_Dismiss	: UIButton!
	@IBOutlet weak var label_AboutApp	: UILabel!
	@IBOutlet weak var label_AboutUs	: UILabel!
	@IBOutlet weak var label_OpenSource	: UILabel!
	
	private let buttonRows = [3, 5]
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
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
		guard buttonRows.contains(indexPath.row) else { return }
		UIView.animate(withDuration: 0.2) {
			tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
		}
	}
	
	override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		guard buttonRows.contains(indexPath.row) else { return }
		UIView.animate(withDuration: 0.2) {
			tableView.cellForRow(at: indexPath)?.backgroundColor = .clear
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard buttonRows.contains(indexPath.row) else { return }
		0.0.id_AfterSecondsPerform {
			switch indexPath.row {
			case 3:
				UIApplication.ID_Open(url: URL(string: "http://www.idco.io/")!)
			case 5:
				UIApplication.ID_Open(url: URL(string: "https://github.com/omidgolparvar/Vazhegan-iOS-Project")!)
			default:
				return
			}
		}
	}
	
	@IBAction func action_ButtonDismiss_Tapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

}

extension AboutController: IDStoryboardInstanceProtocol {
	
}

extension AboutController {
	
	private func setupViews() {
		button_Dismiss.id_RoundCorners()
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
		
		let sections: [(label: UILabel, title: String, text: String)] = [
			(label: label_AboutApp		, title: "برنامه"			, text: .ID_Text(keyName: "AboutAppText")!),
			(label: label_AboutUs		, title: "ما کی هستیم؟!"		, text: .ID_Text(keyName: "AboutUsText")!),
			(label: label_OpenSource	, title: "آ لاو اوپن‌سورس!"	, text: .ID_Text(keyName: "ILoveOpenSourceText")!)
		]
		sections.forEach { (label, title, text) in
			let _title = NSAttributedString(string: title + "\n", attributes: [
				.font: IDFont.Bold.withSize(22),
				.foregroundColor: UIColor.white
				])
			let _text = NSAttributedString(string: text, attributes: [
				.font: IDFont.Regular.withSize(16),
				.foregroundColor: UIColor.white
				])
			let finalAttributedText = _title + _text
			label.attributedText = finalAttributedText
		}
	}
	
	
}

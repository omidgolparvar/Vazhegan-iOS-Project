//
//  AboutController.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import UIKit

class AboutController: UITableViewController {
	
	@IBOutlet weak var labelAboutApp: UILabel!
	@IBOutlet weak var labelAboutUs: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		labelAboutApp.text = V.StringFromPlist(file: "Messages", named: "About_App")
		labelAboutUs.text = V.StringFromPlist(file: "Messages", named: "About_Company")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return [1, 1, 2][section]
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	@IBAction func close(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func actionWebsite(_ sender: UIButton) {
		let w = URL(string : "http://www.idco.io/")!
		if UIApplication.shared.canOpenURL(w) {
			UIApplication.shared.openURL(w)
		}
	}
	
}

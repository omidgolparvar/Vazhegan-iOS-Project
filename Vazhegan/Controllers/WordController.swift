//
//  WordController.swift
//  Vazhegan
//
//  Created by Omid Golparvar on 4/19/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import VazheganFramework
import IDExt

final class WordController: UIViewController {
	
	deinit {
		getMeaningRequest?.cancel()
	}
	
	@IBOutlet weak var label_Title			: UILabel!
	@IBOutlet weak var textView_Meaning		: UITextView!
	@IBOutlet weak var button_Share			: UIButton!
	@IBOutlet weak var button_AddToMyWords	: UIButton!
	@IBOutlet weak var label_DatabaseName	: UILabel!
	@IBOutlet weak var view_DatabaseName	: UIView!
	@IBOutlet weak var view_ButtonsHolder	: UIView!
	@IBOutlet weak var button_Dismiss		: UIButton!
	
	private var getMeaningRequest				: MiniAlamo.DataRequest?
	
	var shouldViewAddToMyWordsButton	: Bool = true
	weak var word		: Word!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		getOrShowMeaning()
    }
	
	@IBAction func action_Dismiss(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func action_ShareWord(_ sender: UIButton) {
		let text: String = word.titlePersian + " " + "(\(word.database.name))" + "\n\n" + word.fullText + "\n\n\n" + "📱 واژگان" + "\n" + V.AppDownloadLink
		self.id_PresentActivityController(forItems: [text], customActivities: nil, sourceView: sender)
	}
	
	@IBAction func action_ToggleForMyWord(_ sender: UIButton) {
		word.toggleForMyWords { (isDeleted) in
			let color: UIColor = isDeleted ? .lightGray : .V
			button_AddToMyWords.setTitleColor(color, for: .normal)
		}
		
	}
	
}

extension WordController: IDStoryboardInstanceProtocol {
	
}

extension WordController {
	
	private func setupViews() {
		button_Dismiss.roundCorners()
		button_Share.setCornerRadius(16)
		button_AddToMyWords.setCornerRadius(16)
		textView_Meaning.font = IDFont.Regular.withSize(16)
		textView_Meaning.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
		view_DatabaseName.setCornerRadius(12)
		
		if !shouldViewAddToMyWordsButton {
			button_AddToMyWords.isHidden = true
		}
		
		setupViews_BasedOnWord()
	}
	
	private func setupViews_BasedOnWord(allData: Bool = false) {
		label_Title.text = word.titlePersian
		label_DatabaseName.text = word.database.name
		
		if allData {
			textView_Meaning.text = word.fullText
			textView_Meaning.textColor = .black
			let color: UIColor = word.isInMyWords ? .V : .lightGray
			button_AddToMyWords.setTitleColor(color, for: .normal)
		}
	}
	
	private func getOrShowMeaning() {
		if word.hasFullMeaning {
			setupViews_BasedOnWord(allData: true)
		} else {
			view_ButtonsHolder.isHidden = true
			textView_Meaning.text = "در حال دریافت..."
			textView_Meaning.textColor = .lightGray
			
			getMeaningRequest = word.getFullMeaning { [weak self] (error) in
				guard let _self = self else { return }
				
				if let error = error {
					_self.textView_Meaning.text = error.description
					_self.textView_Meaning.textColor = .red
					return
				}
				
				_self.view_ButtonsHolder.isHidden = false
				_self.setupViews_BasedOnWord(allData: true)
			}
		}
	}
	
}

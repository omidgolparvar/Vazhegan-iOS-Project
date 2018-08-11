//
//  Word.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public final class Word {
	
	public var data_id		: String?	= ""
	public var id			: String?	= ""
	public var titlePersian	: String?	= ""
	public var titleEnglish	: String?	= ""
	public var db			: String?	= ""
	public var text			: String?	= ""
	public var source		: String?	= ""
	public var number		: NSNumber?	= 0
	
	convenience init(fromJSON data: JSON) {
		self.init()
		id = data[V.Keys.Id].string
		titlePersian = data[V.Keys.TitlePersian].string
		titleEnglish = data[V.Keys.TitleEnglish].string
		text = data[V.Keys.Text].string
		source = data[V.Keys.Source].string
		db = data[V.Keys.DB].string
		number = data[V.Keys.Number].number
	}
	
}

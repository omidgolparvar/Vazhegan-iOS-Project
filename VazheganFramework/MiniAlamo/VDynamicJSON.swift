//
//  VDynamicJSON.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation
import SwiftyJSON

@dynamicMemberLookup
public final class VDynamicJSON {
	
	public var json: MiniAlamo.JSON?
	
	public init(from json: MiniAlamo.JSON?) {
		self.json = json
		
	}
	
	public convenience init?(fromJSONObject jsonObject: MiniAlamo.JSON) {
		self.init(from: jsonObject)
	}
	
	public subscript(dynamicMember member: String) -> VDynamicJSON? {
		return VDynamicJSON(from: self.json?.dictionary?[member])
	}
	
}

extension VDynamicJSON: CustomStringConvertible {
	
	public var description: String {
		return json?.description ?? ""
	}
	
}

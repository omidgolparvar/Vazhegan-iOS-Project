//
//  VError.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum VError: Error, CustomStringConvertible {
	
	case requestWithInvalidResponse
	case errorWithCustomMessage(String)
	case noConnection
	case withData(AnyObject?)
	case unAuthorized
	case unknownError
	
	public var description: String {
		switch self {
		case .requestWithInvalidResponse:
			return "اطلاعات دریافتی معتبر نمی‌باشد"
		case .unknownError:
			return "خطای غیر منتظره‌ای رخ داده است. کمی صبر کنید، و مجدد تلاش نمایید"
		case .errorWithCustomMessage(let message):
			return message
		case .noConnection:
			return "ارتباط با سامانه برقرار نشد. لطفا تنظیمات اینترنت را بررسی نمایید"
		case .withData(let data):
			guard let data = data else { return VError.unknownError.description }
			let jsonObject = JSON(data)
			if let array = jsonObject.array {
				let messages = array.compactMap({ $0["message"].string?.trimmed }).filter({ !$0.isEmpty })
				return messages.isEmpty ? VError.unknownError.description : messages.joined(separator: "\n")
			}
			if let message = jsonObject["message"].string {
				return message
			}
			return VError.unknownError.description
		case .unAuthorized:
			return "می‌بایست مجدد وارد حساب کاربری خود شوید"
		}
	}
	
	public var message: String {
		return self.description
	}
	
}

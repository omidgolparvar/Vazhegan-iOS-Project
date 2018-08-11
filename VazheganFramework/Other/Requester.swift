//
//  Requester.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation
import Alamofire
import SwiftyJSON

public final class Requester {
	
	public typealias CallbackType	= (_ result: Requester.Result, _ data: AnyObject?) -> Void
	
	public enum Result: Int {
		case unknown				= -100
		case notRequested			= -200
		case noConnection			= -300
		
		case success				= 200
		
		case badRequest				= 400
		case unauthorized			= 401
		case forbidden				= 403
		case notFound				= 404
		case methodNotAllowed		= 405
		case unprocessableEntity	= 422
		
		case internalServerError	= 500
		case serviceUnavailable		= 503
	}
	
	public enum Errors: Error, CustomStringConvertible {
		case invalidResponse
		case unknown
		case errorMessage(String)
		case errorMessages([String])
		case noConnection
		case withData(AnyObject?)
		case unAuthorized
		
		public var description: String {
			switch self {
			case .invalidResponse:
				return "اطلاعات دریافتی معتبر نمی‌باشد"
			case .unknown:
				return "خطای غیر منتظره‌ای رخ داده است. کمی صبر کنید، و مجدد تلاش نمایید"
			case .errorMessage(let str):
				return str
			case .errorMessages(let strs):
				return strs.count > 0 ? strs.map { "👈 \($0)" }.joined(separator: "\n") : "خطای غیر منتظره‌ای رخ داده است. کمی صبر کنید، و مجدد تلاش نمایید"
			case .noConnection:
				return "ارتباط با سامانه برقرار نشد. لطفا تنظیمات اینترنت را بررسی نمایید"
			case .withData(let data):
				if let messages = Requester.GetErrorMessages(from: data) {
					return Errors.errorMessages(messages).description
				} else {
					let message = Requester.GetErrorMessage(from: data)
					return message
				}
			case .unAuthorized:
				return "می‌بایست مجدد وارد حساب کاربری خود شوید"
			}
		}
	}
	
	@discardableResult
	public class func Do(method: HTTPMethod, url: String,
				  encoding: ParameterEncoding, parameters: [String: Any]?,
				  hasAuthentication: Bool,
				  then: @escaping CallbackType) -> Request? {
		
		guard isConnectedToNetwork() else { then(.noConnection, nil) ; return nil }
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		return Alamofire
			.request(url, method: method, parameters: parameters, encoding: encoding, headers: nil)
			.responseJSON { response in Requester.HandleResponse(response, then: then) }
		
	}
	
	private class func isConnectedToNetwork() -> Bool {
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}
		var flags = SCNetworkReachabilityFlags()
		if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
			return false
		}
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		return (isReachable && !needsConnection)
	}
	
	private class func HandleResponse(_ response: DataResponse<Any>, then: @escaping CallbackType) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		switch response.result {
		case .success(let data):
			if let result = Requester.Result(rawValue: (response.response?.statusCode)! as Int) {
				then(result, data as AnyObject?)
			} else {
				then(.unknown, data as AnyObject?)
			}
		case .failure(let error):
			print("Requester Error: \(error)")
			then(.notRequested, nil)
		}
	}
	
}

extension Requester {
	
	public typealias ResponseStatus = (status: Bool, error: Error?)
	
	public static func GetStatus(from data: AnyObject?) -> ResponseStatus {
		guard let d = data else { return (false, Errors.invalidResponse) }
		let json = JSON(d)
		guard let status = json["status"].bool else { return (false, Errors.invalidResponse) }
		return (status, status ? nil : Errors.errorMessage(json["message"].string ?? "خطای نامشخصی رخ داده است."))
	}
	
	public static func GetErrorMessage(from data: AnyObject?) -> String {
		guard
			let d = data,
			let message = JSON(d)["message"].string
			else { return "خطای نامشخصی رخ داده است." }
		return message
	}
	
	public static func GetErrorMessages(from data: AnyObject?) -> [String]? {
		guard
			let d = data,
			let messages = (JSON(d).array?.map { $0["message"].string }.flatMap { $0 }), messages.count > 0
			else { return nil }
		return messages
	}
	
	public static func PrintJSON(data: AnyObject?) {
		if let d = data {
			print(JSON(d))
		} else {
			print("[NO JSON OBJECT]")
		}
	}
	
}

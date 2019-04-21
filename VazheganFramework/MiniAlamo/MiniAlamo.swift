import Foundation
import Alamofire
import SwiftyJSON
import SystemConfiguration

public final class MiniAlamo {
	
	public typealias DataRequest		= Alamofire.DataRequest
	public typealias DataResponse		= Alamofire.DataResponse
	public typealias UploadRequest		= Alamofire.UploadRequest
	public typealias Method				= Alamofire.HTTPMethod
	public typealias Encoding			= Alamofire.ParameterEncoding
	public typealias URLEncoding		= Alamofire.URLEncoding
	public typealias JSONEncoding		= Alamofire.JSONEncoding
	public typealias Progress			= Alamofire.Progress
	public typealias Parameters			= Alamofire.Parameters
	public typealias JSON				= SwiftyJSON.JSON
	public typealias UploadParameter	= (name: String, data: Data, fileName: String, mimeType: String)
	public typealias Header				= [String: String]
	public typealias Callback			= (_ result: ResultStatus, _ data: AnyObject?) -> Void
	
	internal static var RequestsDictionary	: [ObjectIdentifier : DataRequest] = [:]
	
	public static var ErrorMessagePrefix	: String			= "⚠️ MiniAlamo - Error:"
	public static var IsVerbose				: Bool				= false
	
	@discardableResult
	public static func Perform(_ endpoint: MiniAlamoEndpointObject, callback: @escaping Callback) -> DataRequest? {
		
		guard isConnectedToNetwork else {
			callback(.noConnection, nil)
			return nil
		}
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		var request: DataRequest?
		request = Alamofire
			.request(endpoint.fullPath, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding, headers: endpoint.headers)
			.responseJSON { response in HandleResponse(request: request, response: response, endpoint: endpoint, callback: callback) }
		
		if let request = request {
			let identifier = ObjectIdentifier(request)
			RequestsDictionary[identifier] = request
		}
		
		return request
	}
	
	public static var isConnectedToNetwork: Bool {
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
	
	public static var isConnectedToVPN: Bool {
		guard
			let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
			let scopes = settings["__SCOPED__"] as? [String:Any]
			else { return false }
		for (key, _) in scopes {
			if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") || key.contains("ipsec0") {
				return true
			}
		}
		return false
	}
	
	public static func PrintData(_ data: AnyObject?) {
		print("MiniAlamo - " + #function + " : ")
		guard let data = data else { print("--- NO Data.") ; return }
		print(MiniAlamo.JSON(data))
	}
	
	public static func CancelRequest(_ request: DataRequest?) {
		guard let request = request else { return }
		request.cancel()
		RequestsDictionary.removeValue(forKey: ObjectIdentifier(request))
		UIApplication.shared.isNetworkActivityIndicatorVisible = !RequestsDictionary.isEmpty
	}
	
	public static func CancelAllRequest() {
		Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
			sessionDataTask.forEach { $0.cancel() }
			uploadData.forEach { $0.cancel() }
			downloadData.forEach { $0.cancel() }
		}
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
	public static func SetupDefaultSessionManager(_ closure: (SessionManager?) -> Void) {
		let defaultSessionManager = Alamofire.SessionManager.default
		closure(defaultSessionManager)
	}
	
}

public extension MiniAlamo {
	
	public enum StatusObject {
		
		public static var ErrorPrefixString		= "⚠️"
		
		case success
		case failedMultipleFieldMessage([(field: String, message: String)])
		case failedWithSingleMessage(String)
		
		public init?(from data: AnyObject?) {
			guard let data = data else { return nil }
			let jsonObject = MiniAlamo.JSON(data)
			if let status = jsonObject["status"].bool, status == true { self = .success }
			else if let status = jsonObject["status"].string, status == "1" { self = .success }
			else if let status = jsonObject["status"].int, status == 1 { self = .success }
			else {
				if let array = jsonObject.array {
					
					let arrayOfFieldMessages: [(String, String)] = array.compactMap { (item) in
						guard
							let field = item["field"].string,
							let message = item["message"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
							else { return nil }
						return (field, message)
					}
					if arrayOfFieldMessages.isEmpty {
						self = .failedWithSingleMessage("خطای نامشخصی رخ داده است.")
					} else {
						self = .failedMultipleFieldMessage(arrayOfFieldMessages)
					}
					
				} else if
					let field = jsonObject["field"].string,
					let message = jsonObject["message"].string?.trimmingCharacters(in: .whitespacesAndNewlines) {
					
					self = .failedMultipleFieldMessage([(field, message)])
					
				} else if let message = jsonObject["message"].string?.trimmingCharacters(in: .whitespacesAndNewlines) {
					
					self = .failedWithSingleMessage(message)
					
				} else {
					self = .failedWithSingleMessage("خطای نامشخصی رخ داده است.")
				}
			}
		}
		
		public var errorMessage: String {
			switch self {
			case .success: return ""
			case .failedWithSingleMessage(let message):
				return message
			case .failedMultipleFieldMessage(let array):
				return array.map({ (item) -> String in
					let field = item.field
					let message = item.message
					if field.isEmpty { return "\(StatusObject.ErrorPrefixString) " + message }
					else { return "\(StatusObject.ErrorPrefixString) " + field + ": " + message }
				}).joined(separator: "\n")
			}
		}
		
	}
	
	public enum ResultStatus: Int {
		
		public static let AllWithoutUnauthorized = Array(200...400) + Array(402..<600)
		
		case unknown				= -100
		case notRequested			= -200
		case noConnection			= -300
		case requestCanceled		= -1001
		
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
	
}

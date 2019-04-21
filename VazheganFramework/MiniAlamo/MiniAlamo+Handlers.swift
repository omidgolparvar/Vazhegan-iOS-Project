import Foundation
import Alamofire

public extension MiniAlamo {
	
	internal static func HandleResponse(request: DataRequest?, response: MiniAlamo.DataResponse<Any>, endpoint: MiniAlamoEndpointObject, callback: @escaping Callback) {
		
		switch response.result {
		case .success(let data):
			if let result = ResultStatus(rawValue: response.response!.statusCode) {
				callback(result, data as AnyObject)
			} else {
				callback(.unknown, data as AnyObject)
			}
		case .failure(let error):
			let nsError = error as NSError
			if MiniAlamo.IsVerbose {
				print(MiniAlamo.ErrorMessagePrefix.trimmingCharacters(in: .whitespacesAndNewlines) + " " + nsError.description)
			}
			
			switch nsError.code {
			case NSURLErrorCancelled:
				callback(.requestCanceled, nil)
			default:
				callback(.notRequested, nil)
			}
		}
		
		if let request = request {
			let identifier = ObjectIdentifier(request)
			RequestsDictionary.removeValue(forKey: identifier)
		}
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = !RequestsDictionary.isEmpty
	}
	
}

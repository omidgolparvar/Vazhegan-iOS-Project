import Foundation

public final class MiniAlamoEndpointObject {
	
	public var identifier		: String?
	public var baseURLString	: String
	public var path				: String
	public var method			: MiniAlamo.Method
	public var encoding			: MiniAlamo.Encoding
	public var parameters		: MiniAlamo.Parameters?
	public var headers			: MiniAlamo.Header?
	
	public var fullPath			: String {
		return baseURLString + path
	}
	
	public init(identifier		: String? = nil,
				baseURLString	: String,
				path			: String,
				method			: MiniAlamo.Method,
				encoding		: MiniAlamo.Encoding,
				parameters		: MiniAlamo.Parameters?,
				headers			: MiniAlamo.Header?) {
		
		self.identifier		= identifier
		self.baseURLString	= baseURLString
		self.path			= path
		self.method			= method
		self.encoding		= encoding
		self.parameters		= parameters
		self.headers		= headers
	}
	
	public func addParameters(_ params: [String: Any]) {
		if self.parameters == nil {
			self.parameters = [:]
		}
		for (key, value) in params {
			self.parameters![key] = value
		}
	}
	
	public func setParameters(_ params: [String: Any]) {
		self.parameters = params
	}
	
	
	
}

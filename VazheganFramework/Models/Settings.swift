import Foundation

fileprivate enum InfoPlistKeys: String {
	case version		= "CFBundleShortVersionString"
	case buildNumber	= "CFBundleVersion"
}

fileprivate extension Bundle {
	func object(forInfoDictionaryKey key: InfoPlistKeys) -> Any? {
		return object(forInfoDictionaryKey: key.rawValue)
	}
}

public enum Settings {
	
	public static var applicationVersion: String {
		let mainBundle = Bundle.main
		let version = mainBundle.object(forInfoDictionaryKey: .version) as! String
		let buildNumber = mainBundle.object(forInfoDictionaryKey: .buildNumber) as! String
		return "v\(version)(\(buildNumber))"
	}
	
}




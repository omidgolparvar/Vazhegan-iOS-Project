import Foundation

public extension String {
	
	var cleanedFromInvalidPersianCharacters: String {
		self
			.replacingOccurrences(of: "ي", with: "ی")
			.replacingOccurrences(of: "ك", with: "ک")
			.replacingOccurrences(of: "ى", with: "ی")
	}
	
	var trimmed: String {
		trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
}

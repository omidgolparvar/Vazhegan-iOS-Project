import Foundation

public extension Sequence {
	
	func sorted <K: Comparable> (by keyPath: KeyPath<Element, K>, ascending: Bool = true) -> [Element] {
		sorted { a, b in
			ascending
				? a[keyPath: keyPath] <= b[keyPath: keyPath]
				: a[keyPath: keyPath] > b[keyPath: keyPath]
		}
	}
	
}

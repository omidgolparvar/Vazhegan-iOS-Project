//

import UIKit

extension UITableView {
	
	static func `default`(with configurator: (UITableView) -> Void) -> UITableView {
		let tableView = UITableView(frame: .zero, style: .insetGrouped) .. {
			$0.register(UITableViewCell.self)
			$0.tableFooterView = UIView()
			$0.contentInsetAdjustmentBehavior = .never
			$0.separatorInset = .zero
			$0.keyboardDismissMode = .onDrag
			$0.showsVerticalScrollIndicator = false
		}
		configurator(tableView)
		return tableView
	}
	
	func register<Cell: UITableViewCell>(
		_ CellType: Cell.Type
	) {
		register(CellType.self, forCellReuseIdentifier: CellType.reuseIdentifier)
	}
	
	func register<HeaderFooterView: UITableViewHeaderFooterView>(
		headerFooterType HeaderFooterType: HeaderFooterView.Type
	) {
		register(HeaderFooterType.self, forHeaderFooterViewReuseIdentifier: HeaderFooterType.reuseIdentifier)
	}
	
	func dequeueReusableCell<Cell: UITableViewCell>(
		_ CellType: Cell.Type,
		for indexPath: IndexPath
	) -> Cell {
		return dequeueReusableCell(withIdentifier: CellType.reuseIdentifier, for: indexPath) as! Cell
	}
	
	func dequeueReusableHeaderFooterView<HeaderFooterView: UITableViewHeaderFooterView>(
		_ HeaderFooterType: HeaderFooterView.Type
	) -> HeaderFooterView {
		return dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterType.reuseIdentifier) as! HeaderFooterView
	}
	
}

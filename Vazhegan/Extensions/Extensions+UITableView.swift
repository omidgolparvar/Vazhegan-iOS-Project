//

import UIKit

extension UITableView {
	
	static func `default`() -> UITableView {
		let tableView = UITableView(frame: .zero, style: .insetGrouped)
		tableView.register(UITableViewCell.self)
		tableView.tableFooterView = UIView()
		tableView.contentInsetAdjustmentBehavior = .never
		tableView.separatorInset = .zero
		tableView.keyboardDismissMode = .onDrag
		tableView.showsVerticalScrollIndicator = false
		
		return tableView
	}
	
	func register<Cell: UITableViewCell>(_ CellType: Cell.Type) {
		register(CellType.self, forCellReuseIdentifier: CellType.reuseIdentifier)
	}
	
	func register<View: UITableViewHeaderFooterView>(headerFooterType ViewType: View.Type) {
		register(ViewType.self, forHeaderFooterViewReuseIdentifier: ViewType.reuseIdentifier)
	}
	
	func dequeueReusableCell<Cell: UITableViewCell>(_ CellType: Cell.Type, for indexPath: IndexPath) -> Cell {
		return dequeueReusableCell(withIdentifier: CellType.reuseIdentifier, for: indexPath) as! Cell
	}
	
	func dequeueReusableHeaderFooterView<View: UITableViewHeaderFooterView>(_ HeaderFooterType: View.Type) -> View {
		return dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterType.reuseIdentifier) as! View
	}
	
}

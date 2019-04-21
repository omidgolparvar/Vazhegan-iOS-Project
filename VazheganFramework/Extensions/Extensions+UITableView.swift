//
//  Extensions+UITableView.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 4/18/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

public extension UITableView {
	
	public func registerVCell<T: VTableViewCell>(cellType: T.Type, bundle: Bundle) {
		let nib = UINib(nibName: cellType.Identifier, bundle: bundle)
		self.register(nib, forCellReuseIdentifier: cellType.Identifier)
	}
	
	public func dequeueReusableVCell<T: VTableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withIdentifier: type.Identifier, for: indexPath) as! T
	}
	
	public func removeExtraSeparatorLines() {
		self.tableFooterView = UIView(frame: .zero)
	}
	
	public func setAutomaticDimensionHeights() {
		self.rowHeight = UITableView.automaticDimension
		self.estimatedRowHeight = UITableView.automaticDimension
	}
	
	public func setDelegateAndDataSource<T: UITableViewDelegate & UITableViewDataSource>(to object: T) {
		self.delegate	= object
		self.dataSource	= object
	}
	
	public func removeBackgroundView() {
		self.backgroundView = nil
	}
	
	public func vCellForItem<T: VTableViewCell>(at indexPath: IndexPath) -> T {
		return self.cellForRow(at: indexPath) as! T
	}
	
}

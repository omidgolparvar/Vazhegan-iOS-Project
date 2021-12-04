//

import UIKit

class SearchResultHeaderView: UITableViewHeaderFooterView {
	
	let titleLabel = UILabel() .. {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.numberOfLines = 4
		$0.textColor = .label
		$0.textAlignment = .right
		$0.font = .pinar(size: 20, weight: .bold)
	}
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		contentView.addSubview(titleLabel) { (maker) in
			maker.centerY.equalToSuperview()
			maker.leading.trailing.equalToSuperview().inset(16)
		}
	}
	
	func configure(text: String) {
		titleLabel.text = text
	}
	
}

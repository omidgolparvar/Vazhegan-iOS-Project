//

import UIKit

class SearchResultHeaderView: UITableViewHeaderFooterView {
	
	let titleLabel = UILabel()
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.numberOfLines = 4
		titleLabel.textColor = .label
		titleLabel.textAlignment = .right
		titleLabel.font = .appFont(size: 20, weight: .bold)
		
		contentView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (maker) in
			maker.centerY.equalToSuperview()
			maker.leading.trailing.equalToSuperview().inset(16)
		}
	}
	
	func configure(text: String) {
		titleLabel.text = text
	}
	
}

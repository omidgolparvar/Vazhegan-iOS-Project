//

import UIKit

final class BackgroundMessageView: UIView {
	
	convenience init(frame: CGRect, data: MessageData) {
		self.init(frame: frame)
		setupViews(data: data)
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("Not Implemented")
	}
	
	private func setupViews(data: MessageData) {
		let stackView = UIStackView(.vertical, spacing: 12)
		addSubview(stackView)
		stackView.snp.makeConstraints { (maker) in
			maker.leading.trailing.equalToSuperview().inset(20)
			maker.centerY.equalToSuperview().offset(-64)
		}
		
		let emojiLabel = UILabel()
		emojiLabel.translatesAutoresizingMaskIntoConstraints = false
		emojiLabel.font = .systemFont(ofSize: 36)
		emojiLabel.textAlignment = .center
		emojiLabel.text = data.emoji
		
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .appFont(size: 20, weight: .bold)
		titleLabel.textAlignment = .center
		titleLabel.numberOfLines = 2
		titleLabel.text = data.title
		
		let subtitleLabel = UILabel()
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
		subtitleLabel.font = .appFont(size: 16)
		subtitleLabel.textAlignment = .center
		subtitleLabel.numberOfLines = 0
		subtitleLabel.text = data.text
		
		stackView.addArrangedSubview(emojiLabel)
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(subtitleLabel)
	}

}

extension BackgroundMessageView {
	
	struct MessageData {
		let emoji: String
		let title: String
		let text: String
	}
	
}

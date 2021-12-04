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
		let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 12)
		addSubview(stackView) { (maker) in
			maker.leading.trailing.equalToSuperview().inset(20)
			maker.centerY.equalToSuperview().offset(-64)
		}
		
		let emojiLabel = UILabel() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.font = .systemFont(ofSize: 36)
			$0.textAlignment = .center
			$0.text = data.emoji
		}
		
		let titleLabel = UILabel() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.font = .pinar(size: 20, weight: .bold)
			$0.textAlignment = .center
			$0.numberOfLines = 2
			$0.text = data.title
		}
		
		let subtitleLabel = UILabel() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.font = .pinar(size: 16)
			$0.textAlignment = .center
			$0.numberOfLines = 0
			$0.text = data.text
		}
		
		stackView.addArrangedSubviews(emojiLabel, titleLabel, subtitleLabel)
	}

}

extension BackgroundMessageView {
	
	struct MessageData {
		let emoji: String
		let title: String
		let text: String
	}
	
}

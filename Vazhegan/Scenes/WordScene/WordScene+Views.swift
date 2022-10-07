//

import Foundation
import UIKit
import Combine

extension WordScene {
	
	final class VerticalAlignedButton: UIButton {
		
		private let stackView = UIStackView(.vertical, alignment: .center, spacing: 4)
		private let symbolImageView = UIImageView()
		private let mainLabel = UILabel()
		
		var buttonConfiguration: ButtonConfiguration {
			didSet { setupViewsBasedOnConfiguration() }
		}
		
		init(configuration: ButtonConfiguration) {
			self.buttonConfiguration = configuration
			super.init(frame: .zero)
			setupViews()
			setupViewsBasedOnConfiguration()
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override var isHighlighted: Bool {
			didSet {
				stackView.alpha = isHighlighted ? 0.5 : 1
			}
		}
		
		override var isEnabled: Bool {
			didSet {
				alpha = isEnabled ? 1 : 0.4
			}
		}
		
		private func setupViews() {
			translatesAutoresizingMaskIntoConstraints = false
			setCornerRadius(16)
			backgroundColor = UIColor(lightMode: .systemGray6, darkMode: .systemGray5)
			tintColor = .label
			
			symbolImageView.tintColor = tintColor
			symbolImageView.translatesAutoresizingMaskIntoConstraints = false
			symbolImageView.contentMode = .scaleAspectFit
			symbolImageView.snp.makeConstraints { (maker) in
				maker.height.equalTo(28)
			}
			
			mainLabel.textColor = tintColor
			mainLabel.translatesAutoresizingMaskIntoConstraints = false
			mainLabel.numberOfLines = 1
			mainLabel.textAlignment = .center
			mainLabel.font = .appFont(size: 13, weight: .medium)
			mainLabel.snp.makeConstraints { (maker) in
				maker.height.equalTo(28)
			}
			
			stackView.isUserInteractionEnabled = false
			stackView.addArrangedSubview(symbolImageView)
			stackView.addArrangedSubview(mainLabel)
			
			addSubview(stackView)
			stackView.snp.makeConstraints { (maker) in
				maker.leading.trailing.equalToSuperview().inset(8)
				maker.centerY.equalToSuperview()
			}
			
			snp.makeConstraints { (maker) in
				maker.height.equalTo(80)
			}
		}
		
		private func setupViewsBasedOnConfiguration() {
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
			let image = UIImage(systemName: buttonConfiguration.symbolName, withConfiguration: symbolConfiguration)
			symbolImageView.image = image
			mainLabel.text = buttonConfiguration.title
		}
		
		override func tintColorDidChange() {
			super.tintColorDidChange()
			symbolImageView.tintColor = tintColor
			mainLabel.textColor = tintColor
		}
		
		struct ButtonConfiguration {
			var symbolName: String
			var title: String
		}
		
	}
	
}

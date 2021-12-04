//

import Foundation
import UIKit
import Combine

extension WordScene {
	
	final class VerticalAlignedButton: UIButton {
		
		private let stackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 4)
		private let symbolImageView = UIImageView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.contentMode = .scaleAspectFit
		}
		private let mainLabel = UILabel() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.numberOfLines = 1
			$0.textAlignment = .center
			$0.font = .pinar(size: 13, weight: .medium)
		}
		
		var configuration: Configuration {
			didSet { setupViewsBasedOnConfiguration() }
		}
		
		var title: String {
			get { configuration.title }
			set { configuration.title = newValue }
		}
		
		var symbolName: String {
			get { configuration.symbolName }
			set { configuration.symbolName = newValue }
		}
		
		init(configuration: Configuration) {
			self.configuration = configuration
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
			setCornerRadius(12)
			backgroundColor = UIColor { (traitCollection) -> UIColor in
				switch traitCollection.userInterfaceStyle {
				case .dark:
					return .systemGray5
				case .light,
					 .unspecified:
					return .systemGray6
				}
			}
			tintColor = .label
			symbolImageView.tintColor = tintColor
			symbolImageView.snp.makeConstraints { (maker) in
				maker.height.equalTo(28)
			}
			mainLabel.textColor = tintColor
			mainLabel.snp.makeConstraints { (maker) in
				maker.height.equalTo(28)
			}
			
			stackView.isUserInteractionEnabled = false
			stackView.addArrangedSubviews(symbolImageView, mainLabel)
			addSubview(stackView) { (maker) in
				maker.leading.trailing.equalToSuperview().inset(8)
				maker.centerY.equalToSuperview()
			}
			
			snp.makeConstraints { (maker) in
				maker.height.equalTo(80)
			}
		}
		
		private func setupViewsBasedOnConfiguration() {
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
			let image = UIImage(systemName: configuration.symbolName, withConfiguration: symbolConfiguration)
			symbolImageView.image = image
			mainLabel.text = configuration.title
		}
		
		override func tintColorDidChange() {
			super.tintColorDidChange()
			symbolImageView.tintColor = tintColor
			mainLabel.textColor = tintColor
		}
		
		struct Configuration {
			var symbolName: String
			var title: String
		}
		
	}
	
}

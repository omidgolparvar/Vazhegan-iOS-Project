//

import Foundation
import UIKit

extension DatabasesScene {
	
	final class DatabaseRowView: UIView, UIContentView {
		let databaseNameLabel = UILabel() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.numberOfLines = 2
			$0.textColor = .label
			$0.textAlignment = .right
			$0.font = .pinar(size: 16, weight: .medium)
		}
		let iconImageView = UIImageView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.contentMode = .scaleAspectFit
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
			let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: symbolConfiguration)
			$0.image = image
		}
		
		var configuration: UIContentConfiguration {
			didSet { configure(configuration: configuration) }
		}
		
		init(_ configuration: UIContentConfiguration) {
			self.configuration = configuration
			super.init(frame: .zero)
			setupViews()
			configure(configuration: self.configuration)
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		private func setupViews() {
			addSubview(iconImageView) { (maker) in
				maker.trailing.equalToSuperview().inset(20)
				maker.size.equalTo(24)
				maker.centerY.equalToSuperview()
			}
			
			addSubview(databaseNameLabel) { (maker) in
				maker.leading.equalToSuperview().inset(16)
				maker.trailing.equalTo(iconImageView.snp.leading).offset(-16)
				maker.top.bottom.equalToSuperview().inset(12)
			}
		}
		
		func configure(configuration: UIContentConfiguration) {
			guard let configuration = configuration as? DatabaseRowViewConfiguration else { return }
			databaseNameLabel.text = configuration.databaseName
			iconImageView.tintColor = configuration.isEnabled
				? .label
				: UIColor { (traitCollection) -> UIColor in
					switch traitCollection.userInterfaceStyle {
					case .dark:
						return .systemGray4
					case .light,
						 .unspecified:
						return .systemGray5
					}
				}
		}
	}
	
	struct DatabaseRowViewConfiguration: UIContentConfiguration {
		let databaseName: String
		let isEnabled: Bool
		
		func makeContentView() -> UIView & UIContentView {
			return DatabaseRowView(self)
		}
		
		func updated(for state: UIConfigurationState) -> Self {
			return self
		}
	}
	
}


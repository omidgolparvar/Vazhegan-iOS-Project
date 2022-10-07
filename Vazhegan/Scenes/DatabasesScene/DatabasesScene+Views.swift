//

import Foundation
import UIKit

extension DatabasesScene {
	
	final class DatabaseRowView: UIView, UIContentView {
		let databaseNameLabel = UILabel()
		let iconImageView = UIImageView()
		
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
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
			let image = UIImage(systemName: .UIImageSystemName.checkmark, withConfiguration: symbolConfiguration)
			iconImageView.image = image
			iconImageView.contentMode = .scaleAspectFit
			
			addSubview(iconImageView)
			iconImageView.snp.makeConstraints { (maker) in
				maker.trailing.equalToSuperview().inset(20)
				maker.size.equalTo(24)
				maker.centerY.equalToSuperview()
			}
			
			databaseNameLabel.numberOfLines = 2
			databaseNameLabel.textColor = .label
			databaseNameLabel.textAlignment = .right
			databaseNameLabel.font = .appFont(size: 16, weight: .medium)
			
			addSubview(databaseNameLabel)
			databaseNameLabel.snp.makeConstraints { (maker) in
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
			: UIColor(lightMode: .systemGray5, darkMode: .systemGray4)
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


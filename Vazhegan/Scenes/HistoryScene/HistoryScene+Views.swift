//

import Foundation
import UIKit
import Combine

extension HistoryScene {
	
	final class QueryRowView: UIView, UIContentView {
		let queryLabel = UILabel()
		let deleteQueryButton = UIButton()
		
		private var cancellable: AnyCancellable?
		private var deleteButtonActionHandler: () -> Void = {}
		
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
			queryLabel.translatesAutoresizingMaskIntoConstraints = false
			queryLabel.numberOfLines = 2
			queryLabel.textColor = .label
			queryLabel.textAlignment = .right
			queryLabel.font = .appFont(size: 16, weight: .semibold)
			
			let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
			let image = UIImage(systemName: .UIImageSystemName.delete, withConfiguration: symbolConfiguration)
			deleteQueryButton.translatesAutoresizingMaskIntoConstraints = false
			deleteQueryButton.tintColor = .systemRed
			deleteQueryButton.setImage(image, for: .normal)
			cancellable = deleteQueryButton
				.tapPublisher
				.sink { [weak self] (_) in
					self?.deleteButtonActionHandler()
				}
			
			addSubview(deleteQueryButton)
			deleteQueryButton.snp.makeConstraints { (maker) in
				maker.trailing.equalToSuperview().inset(20)
				maker.size.equalTo(32)
				maker.centerY.equalToSuperview()
			}
			
			addSubview(queryLabel)
			queryLabel.snp.makeConstraints { (maker) in
				maker.leading.equalToSuperview().inset(16)
				maker.trailing.equalTo(deleteQueryButton.snp.leading).offset(-16)
				maker.top.bottom.equalToSuperview().inset(12)
			}
		}
		
		func configure(configuration: UIContentConfiguration) {
			guard let configuration = configuration as? QueryRowViewConfiguration else { return }
			queryLabel.text = configuration.query
			deleteButtonActionHandler = configuration.deleteHandler
		}
		
	}
	
	struct QueryRowViewConfiguration: UIContentConfiguration {
		let query: String
		let deleteHandler: () -> Void
		
		func makeContentView() -> UIView & UIContentView {
			return QueryRowView(self)
		}
		
		func updated(for state: UIConfigurationState) -> Self {
			return self
		}
	}
	
}

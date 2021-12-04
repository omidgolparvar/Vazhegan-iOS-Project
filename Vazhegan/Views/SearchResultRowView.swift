//

import UIKit

class SearchResultRowView: UIView, UIContentView {
	
	let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 8)
	let meaningLabel = UILabel() .. {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.numberOfLines = 3
		$0.textColor = .label
		$0.textAlignment = .right
		$0.font = .pinar(size: 15, weight: .regular)
	}
	let databaseLabel = UILabel() .. {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.numberOfLines = 4
		$0.textColor = .secondaryLabel
		$0.textAlignment = .right
		$0.font = .pinar(size: 14, weight: .medium)
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
	
	func setupViews() {
		stackView.addArrangedSubviews(meaningLabel, databaseLabel)
		
		addSubview(stackView) { (maker) in
			maker.edges.equalToSuperview().inset(16)
		}
	}
	
	func configure(configuration: UIContentConfiguration) {
		guard let configuration = configuration as? SearchResultRowViewConfiguration else { return }
		meaningLabel.text = configuration.meaning
		databaseLabel.text = configuration.database
	}
	
}

struct SearchResultRowViewConfiguration: UIContentConfiguration {
	let meaning: String
	let database: String
	
	func makeContentView() -> UIView & UIContentView {
		return SearchResultRowView(self)
	}
	
	func updated(for state: UIConfigurationState) -> SearchResultRowViewConfiguration {
		return self
	}
	
}

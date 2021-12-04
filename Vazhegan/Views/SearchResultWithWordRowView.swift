//

import UIKit

class SearchResultWithWordRowView: SearchResultRowView {
	
	let wordLabel = UILabel() .. {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.numberOfLines = 4
		$0.textColor = .label
		$0.textAlignment = .right
		$0.font = .pinar(size: 18, weight: .semibold)
	}
	
	override init(_ configuration: UIContentConfiguration) {
		super.init(configuration)
		self.configuration = configuration
		setupViews()
		configure(configuration: self.configuration)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupViews() {
		super.setupViews()
		stackView.insertArrangedSubview(wordLabel, at: 0)
	}
	
	override func configure(configuration: UIContentConfiguration) {
		guard let configuration = configuration as? SearchResultWithWordRowViewConfiguration else { return }
		meaningLabel.text = configuration.meaning
		databaseLabel.text = configuration.database
		wordLabel.text = configuration.word
	}
	
}

struct SearchResultWithWordRowViewConfiguration: UIContentConfiguration {
	let word: String
	let meaning: String
	let database: String
	
	func makeContentView() -> UIView & UIContentView {
		return SearchResultWithWordRowView(self)
	}
	
	func updated(for state: UIConfigurationState) -> SearchResultWithWordRowViewConfiguration {
		return self
	}
}

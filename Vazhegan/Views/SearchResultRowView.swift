//

import UIKit

class SearchResultRowView: UIView, UIContentView {
	
	private let stackView = UIStackView(.vertical)
	let wordLabel = UILabel()
	let meaningLabel = UILabel()
	let databaseLabel = UILabel()
	
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
		wordLabel.translatesAutoresizingMaskIntoConstraints = false
		wordLabel.numberOfLines = 4
		wordLabel.textColor = .label
		wordLabel.textAlignment = .right
		wordLabel.font = .appFont(size: 18, weight: .semibold)
		
		meaningLabel.translatesAutoresizingMaskIntoConstraints = false
		meaningLabel.numberOfLines = 3
		meaningLabel.textColor = .label
		meaningLabel.textAlignment = .right
		meaningLabel.font = .appFont(size: 15, weight: .regular)
		
		databaseLabel.translatesAutoresizingMaskIntoConstraints = false
		databaseLabel.numberOfLines = 4
		databaseLabel.textColor = .secondaryLabel
		databaseLabel.textAlignment = .right
		databaseLabel.font = .appFont(size: 14, weight: .medium)
		
		stackView.addArrangedSubview(wordLabel)
		stackView.addArrangedSubview(meaningLabel)
		stackView.addArrangedSubview(databaseLabel)
		
		addSubview(stackView)
		stackView.snp.makeConstraints { (maker) in
			maker.edges.equalToSuperview().inset(16)
		}
	}
	
	func configure(configuration: UIContentConfiguration) {
		guard let configuration = configuration as? SearchResultRowViewConfiguration else { return }
		wordLabel.text = configuration.word
		wordLabel.isHidden = configuration.word == nil
		meaningLabel.text = configuration.meaning
		databaseLabel.text = configuration.database
	}
	
}

struct SearchResultRowViewConfiguration: UIContentConfiguration {
	let word: String?
	let meaning: String
	let database: String
	
	func makeContentView() -> UIView & UIContentView {
		return SearchResultRowView(self)
	}
	
	func updated(for state: UIConfigurationState) -> SearchResultRowViewConfiguration {
		return self
	}
	
}

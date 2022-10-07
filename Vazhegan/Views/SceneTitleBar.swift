//

import UIKit
import Combine

class SceneTitleBar: UIView {
	
	private let buttonsStackView = UIStackView(.horizontal, alignment: .center, spacing: 20)
	let titleLabel = UILabel()
	let dismissButton = UIButton()
	
	private var cancellable: AnyCancellable?
	
	init() {
		super.init(frame: .zero)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .systemBackground
		
		let dividerView = UIView()
		dividerView.translatesAutoresizingMaskIntoConstraints = false
		dividerView.backgroundColor = .systemGray6
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.numberOfLines = 4
		titleLabel.textColor = .label
		titleLabel.textAlignment = .right
		titleLabel.font = .appFont(size: 22, weight: .bold)
		addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (maker) in
			maker.centerY.equalToSuperview()
			maker.leading.trailing.equalToSuperview().inset(16)
		}
		
		buttonsStackView.semanticContentAttribute = .forceLeftToRight
		addSubview(buttonsStackView)
		buttonsStackView.snp.makeConstraints { (maker) in
			maker.centerY.equalToSuperview()
			maker.trailing.equalToSuperview().inset(20)
		}
		addSubview(dividerView)
		dividerView.snp.makeConstraints { (maker) in
			maker.leading.trailing.bottom.equalToSuperview()
			maker.height.equalTo(1)
		}
		
		let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
		let image = UIImage(systemName: .UIImageSystemName.close, withConfiguration: symbolConfiguration)
		dismissButton.translatesAutoresizingMaskIntoConstraints = false
		dismissButton.tintColor = .label
		dismissButton.backgroundColor = .systemGray5
		dismissButton.setImage(image, for: .normal)
		dismissButton.setCornerRadius(14, cornerCurve: .circular)
		dismissButton.snp.makeConstraints { (maker) in
			maker.size.equalTo(28)
		}
		
		buttonsStackView.addArrangedSubview(dismissButton)
	}
	
	func added(to viewController: UIViewController) {
		titleLabel.text = viewController.title
		
		cancellable = dismissButton
			.tapPublisher
			.sink { [unowned viewController] (_) in
				viewController.dismiss(animated: true, completion: nil)
			}
		
		viewController.view.addSubview(self)
		self.snp.makeConstraints { (maker) in
			maker.top.equalTo(viewController.view.safeAreaLayoutGuide)
			maker.leading.trailing.equalTo(viewController.view)
			maker.height.equalTo(80)
		}
	}
	
	func addButton(_ button: UIButton) {
		buttonsStackView.addArrangedSubview(button)
	}
	
}

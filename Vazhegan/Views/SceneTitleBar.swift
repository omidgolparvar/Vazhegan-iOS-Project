//

import UIKit
import Combine

class SceneTitleBar: UIView {
	
	let titleLabel = UILabel() .. {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.numberOfLines = 4
		$0.textColor = .label
		$0.textAlignment = .right
		$0.font = .pinar(size: 22, weight: .bold)
	}
	let dismissButton = UIButton() .. {
		let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
		let image = UIImage(systemName: "xmark", withConfiguration: symbolConfiguration)
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.tintColor = .systemGray
		$0.setImage(image, for: .normal)
		$0.snp.makeConstraints { (maker) in
			maker.size.equalTo(32)
		}
	}
	
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
		
		let dividerView = UIView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.backgroundColor = .systemGray6
		}
		
		addSubview(titleLabel) { (maker) in
			maker.centerY.equalToSuperview()
			maker.leading.trailing.equalToSuperview().inset(16)
		}
		addSubview(dismissButton) { (maker) in
			maker.centerY.equalToSuperview()
			maker.trailing.equalToSuperview().inset(20)
		}
		addSubview(dividerView) { (maker) in
			maker.leading.trailing.bottom.equalToSuperview()
			maker.height.equalTo(1)
		}
	}
	
	func added(to viewController: UIViewController) {
		titleLabel.text = viewController.title
		
		cancellable = dismissButton
			.tapPublisher
			.sink { [unowned viewController] (_) in
				viewController.dismiss(animated: true, completion: nil)
			}
		
		viewController.view.addSubview(self) { (maker) in
			maker.top.equalTo(viewController.view.safeAreaLayoutGuide)
			maker.leading.trailing.equalTo(viewController.view)
			maker.height.equalTo(80)
		}
	}
}

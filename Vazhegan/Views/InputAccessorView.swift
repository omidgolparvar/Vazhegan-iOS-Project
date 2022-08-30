//

import UIKit
import Combine

class InputAccessorView: UIView {
	
	private let dismissButton = UIButton()
	private weak var responder: UIResponder?
	private var tokens = Set<AnyCancellable>()
	
	init(responder: UIResponder) {
		self.responder = responder
		super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56))
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		backgroundColor = .clear
		setupDismissButton()
	}
	
	private func setupDismissButton() {
		let configuration = UIImage.SymbolConfiguration(scale: .medium)
		let image = UIImage(systemName: "keyboard.chevron.compact.down", withConfiguration: configuration)
		
		dismissButton.tintColor = .label
		dismissButton.backgroundColor = .systemGray5
		dismissButton.setImage(image, for: .normal)
		dismissButton.layer.cornerRadius = 22
		
		dismissButton
			.tapPublisher
			.sink { [unowned self] in
				self.responder?.resignFirstResponder()
			}
			.store(in: &tokens)
		
		addSubview(dismissButton)
		dismissButton.snp.makeConstraints { make in
			make.size.equalTo(44)
			make.top.centerX.equalToSuperview()
		}
	}

}

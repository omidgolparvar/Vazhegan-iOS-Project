//

import Foundation
import UIKit
import Combine

extension MainScene {
	
	final class SearchField: UITextField {
		
		private let clearButton = UIButton(frame: .init(x: 0, y: 0, width: 44, height: 44))
		
		var queryPublisher: AnyPublisher<String, Never> {
			returnPublisher
				.map({ [unowned self] _ in self.text })
				.replaceNil(with: "")
				.map(\.trimmed)
				.filter { !$0.isEmpty }
				.eraseToAnyPublisher()
		}
		
		private var fieldDidClearSubject = PassthroughSubject<Void, Never>()
		var fieldDidClearPubisher: AnyPublisher<Void, Never> {
			fieldDidClearSubject.eraseToAnyPublisher()
		}
		
		override var isEnabled: Bool {
			didSet {
				textColor = isEnabled ? .label : .systemGray
				backgroundColor = isEnabled ? .systemGray6 : .systemGray5
			}
		}
		
		private var tokens = Set<AnyCancellable>()
		
		init() {
			super.init(frame: .zero)
			setupViews()
			setupBindings()
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func textRect(forBounds bounds: CGRect) -> CGRect {
			let insetRect = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 44)
			return bounds.inset(by: insetRect)
		}
		
		override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
			textRect(forBounds: bounds)
		}
		
		override func editingRect(forBounds bounds: CGRect) -> CGRect {
			textRect(forBounds: bounds)
		}
		
		private func setupViews() {
			translatesAutoresizingMaskIntoConstraints = false
			textAlignment = .right
			setCornerRadius(12)
			backgroundColor = .systemGray6
			returnKeyType = .search
			font = .appFont(size: 16, weight: .medium)
			autocorrectionType = .no
			setupPlaceholder()
			setupSearchIcon()
			setupClearButton()
		}
		
		private func setupPlaceholder() {
			attributedPlaceholder = NSAttributedString(
				R.string.mainScene.searchFieldPlaceholder(),
				font: .appFont(size: 16),
				textColor: .systemGray2
			)
		}
		
		private func setupSearchIcon() {
			let configuration = UIImage.SymbolConfiguration(scale: .large)
			let image = UIImage(systemName: .UIImageSystemName.search, withConfiguration: configuration)
			let imageView = UIImageView(frame: .init(x: 10, y: 10, width: 24, height: 24))
			imageView.image = image
			imageView.contentMode = .scaleAspectFit
			imageView.tintColor = .label
			
			let holderView = UIView(frame: .init(x: 0, y: 0, width: 44, height: 44))
			holderView.addSubview(imageView)
			
			if #available(iOS 16, *) {
				rightView = holderView
				rightViewMode = .always
			} else {
				leftView = holderView
				leftViewMode = .always
			}
		}
		
		private func setupClearButton() {
			let holderView = UIView(frame: .init(x: 0, y: 0, width: 44, height: 44))
			holderView.addSubview(clearButton)
			
			let configuration = UIImage.SymbolConfiguration(scale: .medium)
			let image = UIImage(systemName: .UIImageSystemName.close, withConfiguration: configuration)
			
			clearButton.tintColor = .label
			clearButton.setImage(image, for: .normal)
			
			if #available(iOS 16, *) {
				leftView = holderView
				leftViewMode = .always
			} else {
				rightView = holderView
				rightViewMode = .always
			}
		}
		
		private func setupBindings() {
			textPublisher
				.replaceNil(with: "")
				.map(\.isEmpty)
				.sink { [unowned self] isEmpty in
					self.clearButton.isEnabled = !isEmpty
					self.clearButton.alpha = isEmpty ? 0 : 1
				}
				.store(in: &tokens)
			
			clearButton
				.tapPublisher
				.sink { [unowned self] in
					self.setText("")
					self.fieldDidClearSubject.send()
				}
				.store(in: &tokens)
		}
		
		func setText(_ text: String) {
			self.text = text.trimmed
			clearButton.isEnabled = !text.isEmpty
			clearButton.alpha = text.isEmpty ? 0 : 1
		}
		
	}
	
}

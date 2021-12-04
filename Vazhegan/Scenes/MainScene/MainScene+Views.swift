//

import Foundation
import UIKit
import Combine

extension MainScene {
	
	final class SearchField: UITextField {
		
		var queryPublisher: AnyPublisher<String, Never> {
			returnPublisher
				.map({ [unowned self] _ in self.text })
				.replaceNil(with: "")
				.map(\.trimmed)
				.filter { !$0.isEmpty }
				.eraseToAnyPublisher()
		}
		
		override var isEnabled: Bool {
			didSet {
				textColor = isEnabled ? .label : .systemGray
				backgroundColor = isEnabled ? .systemGray6 : .systemGray5
			}
		}
		
		init() {
			super.init(frame: .zero)
			setupViews()
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
			font = UIFont.pinar(size: 16, weight: .medium)
			autocorrectionType = .no
			setupPlaceholder()
			setupSearchIcon()
		}
		
		private func setupPlaceholder() {
			attributedPlaceholder = NSAttributedString(
				string: "آن چیز که در جستن آنی، همونی",
				attributes: [
					.foregroundColor: UIColor.systemGray2,
					.font: UIFont.pinar(size: 16)
				]
			)
		}
		
		private func setupSearchIcon() {
			let holderView = UIView(frame: .init(x: 0, y: 0, width: 44, height: 44))
			
			let configuration = UIImage.SymbolConfiguration(scale: .large)
			let image = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
			let imageView = UIImageView(frame: .init(x: 10, y: 10, width: 24, height: 24)) .. {
				$0.image = image
				$0.contentMode = .scaleAspectFit
				$0.tintColor = .label
			}
			
			holderView.addSubview(imageView)
			
			leftView = holderView
			leftViewMode = .always
		}
		
		func setText(_ text: String) {
			self.text = text.trimmed
		}
		
	}
	
}

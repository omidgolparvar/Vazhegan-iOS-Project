//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

extension WordScene {
	
	final class Controller: SceneController {
		
		private let sceneBar = SceneTitleBar()
		private let buttonsContainerView = UIView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		private let shareButton = VerticalAlignedButton(configuration: .init(
			symbolName: "square.and.arrow.up",
			title: "اشتراک‌گذاری"
		))
		private let favoriteButton = VerticalAlignedButton(configuration: .init(
			symbolName: "star",
			title: "ذخیره"
		))
		private let moreButton = VerticalAlignedButton(configuration: .init(
			symbolName: "list.bullet.rectangle",
			title: "بیشتر"
		))
		private let textView = UITextView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.font = .pinar(size: 18)
			$0.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
			$0.isEditable = false
			$0.textColor = .label
			$0.textAlignment = .right
			$0.showsVerticalScrollIndicator = false
		}
		
		private let viewModel: ViewModel
		private var router: Router
		
		init(viewModel: ViewModel) {
			self.viewModel = viewModel
			self.router = Router()
			super.init(nibName: nil, bundle: nil)
			self.router.sourceController = self
			self.router.dataProvider = nil
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func viewDidLoad() {
			super.viewDidLoad()
			setupViews()
			setupBindings()
			
			viewModel.getMeaning()
		}
		
		private func setupViews() {
			title = viewModel.originalWord.nonEmptyTitle
			view.backgroundColor = .systemBackground
			sceneBar.added(to: self)
			setupButtons()
			setupTextView()
		}
		
		private func setupButtons() {
			let dividerView = UIView() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.backgroundColor = UIColor { (traitCollection) -> UIColor in
					switch traitCollection.userInterfaceStyle {
					case .dark:
						return .systemGray5
					case .light,
						 .unspecified:
						return .systemGray6
					}
				}
			}
			buttonsContainerView.addSubview(dividerView) { (maker) in
				maker.leading.trailing.top.equalToSuperview()
				maker.height.equalTo(1)
			}
			
			let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 8)
			stackView.addArrangedSubviews(shareButton, favoriteButton, moreButton)
			buttonsContainerView.addSubview(stackView) { (maker) in
				maker.edges.equalToSuperview().inset(16)
			}
			
			view.addSubview(buttonsContainerView) { (maker) in
				maker.leading.trailing.equalToSuperview()
				maker.bottom.equalTo(view.safeAreaLayoutGuide)
			}
		}
		
		private func setupTextView() {
			view.addSubview(textView) { (maker) in
				maker.top.equalTo(sceneBar.snp.bottom)
				maker.leading.trailing.equalToSuperview().inset(12)
				maker.bottom.equalTo(buttonsContainerView.snp.top)
			}
		}
		
		private func setupTextViewContent(with text: String) {
			let html = """
				<html lang="fa" dir="rtl">
				  <head>
				    <style>body { font-family: 'Pinar-Regular'; font-size:18px; }</style>
				    <meta charset="utf-8"/>
				  </head>
				  <body>
				    \(text)
				  </body>
				</html>
				"""
			
			if let data = html.data(using: .utf8),
			   let attributedString = try? NSAttributedString(
				data: data,
				options: [.documentType: NSAttributedString.DocumentType.html],
				documentAttributes: nil) {
				textView.attributedText = attributedString
				textView.textColor = .label
			} else {
				textView.text = text
			}
		}
		
		private func setupBindings() {
			setupButtonsBindings()
			setupViewModelBindings()
		}
		
		private func setupButtonsBindings() {
			moreButton
				.tapPublisher
				.sink { [unowned self] (_) in
					guard case .success(let word) = self.viewModel.getMeaningStatus else { return }
					self.router.openVajehyabWebsite(for: word)
				}
				.store(in: &cancellables)
			
			shareButton
				.tapPublisher
				.sink { [unowned self] (_) in
					guard let shareText = self.viewModel.shareText else { return }
					self.router.presentShareController(with: [shareText])
				}
				.store(in: &cancellables)
			
			favoriteButton
				.tapPublisher
				.sink { [unowned self] (_) in
					self.viewModel.toggleIsFavoriteStatus()
				}
				.store(in: &cancellables)
		}
		
		private func setupViewModelBindings() {
			viewModel
				.$getMeaningStatus
				.receive(on: DispatchQueue.main)
				.sink { [weak self] (status) in
					guard let self = self else { return }
					
					switch status {
					case .notRequested:
						break
					case .loading:
						self.textView.text = "در حال دریافت..."
					case .success(let word):
						self.setupTextViewContent(with: word.fullText)
					case .failed(let error):
						print(#function, error)
						self.textView.text = "خطایی رخ داد. 😬"
					}
				}
				.store(in: &cancellables)
			
			viewModel
				.$getMeaningStatus
				.receive(on: DispatchQueue.main)
				.map { (status) -> Bool in
					switch status {
					case .notRequested,
						 .loading,
						 .failed:
						return false
					case .success:
						return true
					}
				}
				.sink { [weak self] (isEnabled) in
					guard let self = self else { return }
					let buttons = [self.shareButton, self.favoriteButton, self.moreButton]
					buttons.forEach {
						$0.isEnabled = isEnabled
					}
				}
				.store(in: &cancellables)
			
			viewModel
				.$isWordFavorited
				.map { isFavorite in
					VerticalAlignedButton.ButtonConfiguration(
						symbolName: isFavorite ? "star.fill" : "star",
						title: isFavorite ? "حذف" : "ذخیره"
					)
				}
				.assign(to: \.buttonConfiguration, on: favoriteButton)
				.store(in: &cancellables)
		}
		
	}
	
}

//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

extension WordScene {
	
	final class Controller: SceneController {
		
		private let sceneBar = SceneTitleBar()
		private let buttonsContainerView = UIView()
		private let shareButton = VerticalAlignedButton(configuration: .init(
			symbolName: .UIImageSystemName.share,
			title: R.string.wordScene.shareButtonTitle()
		))
		private let favoriteButton = VerticalAlignedButton(configuration: .init(
			symbolName: .UIImageSystemName.favorite,
			title: R.string.wordScene.saveButtonTitle()
		))
		private let moreButton = VerticalAlignedButton(configuration: .init(
			symbolName: .UIImageSystemName.more,
			title: R.string.wordScene.moreButtonTitle()
		))
		private let textView = UITextView()
		private let topDividerView = UIView()
		
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
			setupDividerView()
			setupButtons()
			setupTextView()
		}
		
		private func setupDividerView() {
			topDividerView.backgroundColor = UIColor(lightMode: .systemGray6, darkMode: .systemGray5)
			
			view.addSubview(topDividerView)
			topDividerView.snp.makeConstraints { (maker) in
				maker.top.equalTo(sceneBar.snp.bottom)
				maker.leading.trailing.equalToSuperview()
				maker.height.equalTo(1)
			}
		}
		
		private func setupButtons() {
			let dividerView = UIView()
			dividerView.backgroundColor = UIColor(lightMode: .systemGray6, darkMode: .systemGray5)
			buttonsContainerView.addSubview(dividerView)
			dividerView.snp.makeConstraints { (maker) in
				maker.leading.trailing.top.equalToSuperview()
				maker.height.equalTo(1)
			}
			
			let stackView = UIStackView(.horizontal, distribution: .fillEqually)
			stackView.addArrangedSubview(shareButton)
			stackView.addArrangedSubview(favoriteButton)
			stackView.addArrangedSubview(moreButton)
			
			buttonsContainerView.addSubview(stackView)
			stackView.snp.makeConstraints { (maker) in
				maker.edges.equalToSuperview().inset(16)
			}
			
			view.addSubview(buttonsContainerView)
			buttonsContainerView.snp.makeConstraints { (maker) in
				maker.leading.trailing.equalToSuperview()
				maker.bottom.equalTo(view.safeAreaLayoutGuide)
			}
		}
		
		private func setupTextView() {
			textView.font = .appFont(size: 18)
			textView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
			textView.isEditable = false
			textView.textColor = .label
			textView.textAlignment = .right
			textView.showsVerticalScrollIndicator = false
			
			view.addSubview(textView)
			textView.snp.makeConstraints { (maker) in
				maker.top.equalTo(topDividerView.snp.bottom)
				maker.leading.trailing.equalToSuperview().inset(12)
				maker.bottom.equalTo(buttonsContainerView.snp.top)
			}
		}
		
		private func setupTextViewContent(with text: String) {
			let html = """
				<html lang="fa" dir="rtl">
				  <head>
				    <style>body { font-family: '\(UIFont.appFont(size: 1).familyName)'; font-size:18px; }</style>
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
						self.textView.text = R.string.wordScene.loadingText()
					case .success(let word):
						self.setupTextViewContent(with: word.fullText)
					case .failed(let error):
						print(#function, error)
						self.textView.text = R.string.wordScene.errorText()
					}
				}
				.store(in: &cancellables)
			
			viewModel
				.$getMeaningStatus
				.receive(on: DispatchQueue.main)
				.map { (status) -> Bool in
					if case .success = status {
						return true
					}
					return false
				}
				.sink { [weak self] (isEnabled) in
					guard let self = self else { return }
					for button in [self.shareButton, self.favoriteButton, self.moreButton] {
						button.isEnabled = isEnabled
					}
				}
				.store(in: &cancellables)
			
			viewModel
				.$isWordFavorited
				.map { isFavorite in
					VerticalAlignedButton.ButtonConfiguration(
						symbolName: isFavorite ? .UIImageSystemName.filledFavorite : .UIImageSystemName.favorite,
						title: isFavorite ? R.string.wordScene.removeButtonTitle() : R.string.wordScene.saveButtonTitle()
					)
				}
				.assign(to: \.buttonConfiguration, on: favoriteButton)
				.store(in: &cancellables)
		}
		
	}
	
}

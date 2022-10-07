//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

extension AboutScene {
	
	final class Controller: SceneController {
		
		private let scrollView = UIScrollView()
		private let mainView = UIView()
		private let mainStackView = UIStackView(.vertical, spacing: 24)
		
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
		}
		
		// MARK: - Setup Views
		
		private func setupViews() {
			view.backgroundColor = .systemBackground
			setupMainContainerViews()
			
			let appLogoContainerView = makeAppLogoContainerView()
			mainStackView.addArrangedSubview(appLogoContainerView)
			mainStackView.setCustomSpacing(8, after: appLogoContainerView)
			
			mainStackView.addArrangedSubview(makeTextsView(
				title: nil,
				text: R.string.aboutScene.aboutAppSectionText()
			))
			
			mainStackView.addArrangedSubview(makeDividerView())
			
			mainStackView.addArrangedSubview(makeTextsView(
				title: R.string.aboutScene.openSourceSectionTitle(),
				text: R.string.aboutScene.openSourceSectionText()
			))
			
			mainStackView.addArrangedSubview(makeButton(
				title: R.string.aboutScene.githubTitle(),
				titleColor: .systemBackground,
				backgroundColor: .label) { [unowned self] in
					self.router.openURL(URL(string: V.Constants.appDownloadLink)!)
				}
			)
			
			mainStackView.addArrangedSubview(makeDividerView())
			
			mainStackView.addArrangedSubview(makeShareAppButton())
			
			mainStackView.addArrangedSubview(makeDividerView())
			
			let linkedInButton = makeButton(
				title: SocialNetwork.linkedIn.name,
				titleColor: .white,
				backgroundColor: SocialNetwork.linkedIn.color) { [unowned self] in
				self.router.openURL(SocialNetwork.linkedIn.link)
			}
			mainStackView.addArrangedSubview(linkedInButton)
			mainStackView.setCustomSpacing(40, after: linkedInButton)
			
			mainStackView.addArrangedSubview(makeVersionLabel())
			
			mainStackView.addArrangedSubview(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 50))))
		}
		
		private func setupMainContainerViews() {
			scrollView.showsVerticalScrollIndicator = false
			scrollView.alwaysBounceVertical = true
			view.addSubview(scrollView)
			scrollView.snp.makeConstraints { (maker) in
				maker.edges.equalTo(view)
			}
			
			mainView.backgroundColor = .systemBackground
			scrollView.addSubview(mainView)
			mainView.snp.makeConstraints { (maker) in
				maker.edges.equalTo(scrollView)
				maker.height.lessThanOrEqualTo(view).priority(.low)
				maker.width.equalTo(view)
			}
			
			mainStackView.isLayoutMarginsRelativeArrangement = true
			mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
			mainView.addSubview(mainStackView)
			mainStackView.snp.makeConstraints { (maker) in
				maker.edges.equalTo(mainView)
			}
		}
		
		// MARK: - View Makers
		
		private func makeTextsView(title: String?, text: String) -> UIView {
			let stackView = UIStackView(.vertical)
			if let title = title {
				stackView.addArrangedSubview(makeTitleLabel(text: title))
			}
			stackView.addArrangedSubview(makeTextLabel(text: text))
			
			let containerView = UIView()
			containerView.translatesAutoresizingMaskIntoConstraints = false
			containerView.addSubview(stackView)
			stackView.snp.makeConstraints { (maker) in
				maker.edges.equalToSuperview()
			}
			
			return containerView
		}
		
		private func makeTitleLabel(text: String) -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.numberOfLines = 0
			label.textColor = .label
			label.textAlignment = .right
			label.font = .appFont(size: 20, weight: .bold)
			label.text = text
			
			return label
		}
		
		private func makeTextLabel(text: String) -> UILabel {
			let label = UILabel()
			label.numberOfLines = 0
			label.textColor = .label
			label.textAlignment = .right
			label.font = .appFont(size: 15, weight: .regular)
			label.text = text
			
			return label
		}
		
		private func makeButton(
			title: String,
			titleColor: UIColor,
			backgroundColor: UIColor,
			handler: @escaping () -> Void
		) -> UIButton {
			let button = UIButton()
			button.setTitle(title, for: .normal)
			button.setTitleColor(titleColor, for: .normal)
			button.setCornerRadius(16)
			button.titleLabel?.font = .appFont(size: 16, weight: .semibold)
			button.backgroundColor = backgroundColor
			button.snp.makeConstraints { (maker) in
				maker.height.equalTo(52)
			}
			button
				.tapPublisher
				.sink(receiveValue: handler)
				.store(in: &cancellables)
			
			return button
		}
		
		private func makeDividerView() -> UIView {
			let view = UIView()
			view.backgroundColor = UIColor(lightMode: .systemGray6, darkMode: .systemGray5)
			view.snp.makeConstraints { (maker) in
				maker.height.equalTo(1)
			}
			
			return view
		}
		
		private func makeVersionLabel() -> UILabel {
			let label = UILabel()
			label.text = Settings.applicationVersion
			label.textColor = .secondaryLabel
			label.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
			label.textAlignment = .center
			
			return label
		}
		
		private func makeAppLogoContainerView() -> UIView {
			let logoContainerView = UIView()
			
			let containerView = UIView()
			containerView.setCornerRadius(14)
			containerView.backgroundColor = .label
			
			let vLabel = UILabel()
			vLabel.text = R.string.mainScene.v()
			vLabel.font = .appFont(size: 44, weight: .bold)
			vLabel.textAlignment = .center
			vLabel.textColor = .systemBackground
			
			containerView.addSubview(vLabel)
			vLabel.snp.makeConstraints {
				$0.centerX.equalToSuperview()
				$0.centerY.equalToSuperview().offset(-7)
			}
			
			logoContainerView.addSubview(containerView)
			containerView.snp.makeConstraints { maker in
				maker.top.bottom.leading.equalToSuperview()
				maker.size.equalTo(64)
			}
			
			return logoContainerView
		}
		
		private func makeShareAppButton() -> UIView {
			let button = makeButton(
				title: R.string.aboutScene.shareAppTitle(),
				titleColor: .systemBackground,
				backgroundColor: .label) { [unowned self] in
				self.router.presentShareController(with: [self.viewModel.shareText])
			}
			
			let containerView = UIView()
			containerView.addSubview(button)
			button.snp.makeConstraints { make in
				make.edges.equalToSuperview()
			}
			
			return containerView
		}
		
	}
	
}

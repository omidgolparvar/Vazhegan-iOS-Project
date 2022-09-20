//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import VazheganFramework

extension AboutScene {
	
	final class Controller: SceneController {
		
		private let scrollView = UIScrollView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.showsVerticalScrollIndicator = false
			$0.alwaysBounceVertical = true
		}
		private let mainView = UIView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.backgroundColor = .systemBackground
		}
		private let mainStackView = UIStackView() .. {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.axis = .vertical
			$0.alignment = .fill
			$0.distribution = .fill
			$0.isLayoutMarginsRelativeArrangement = true
			$0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
			$0.spacing = 24
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
		}
		
		// MARK: - Setup Views
		
		private func setupViews() {
			view.backgroundColor = .systemBackground
			setupMainContainerViews()
			
			let aboutAppSection = makeTextsView(
				title: "درباره برنامه",
				text: """
				«واژگان» یه فرهنگ لغته. با استفاده از این نرم‌افزار می‌تونین خیلی راحت، معنی کلمات مورد نظرتون رو توی فرهنگ لغت‌های مختلف ببینین. البته باید این نکته رو هم بگیم که این نرم‌افزار تماما داره از پایگاه داده‌ها و واسط برنامه‌نویسی «واژه‌یاب» استفاده می‌کنه؛ دم‌شون گرم!! 😂
				همچنین برای راحتی بیشتر، می‌تونین توی نرم‌افزارهای دیگه، کلمه مورد نظرتون رو انتخاب کنین، گزینه Share رو بزنین و بعد «واژگان» رو انتخاب کنین، تا بدون اینکه از نرم‌افزار فعلی‌تون خارج بشین، معنی کلمه براتون نمایش داده بشه. 😉😎
				"""
			)
			
			let iLoveOpenSource = makeTextsView(
				title: "آی لاو اوپن‌سورس",
				text: """
				این پروژه، پروژه خیلی کوچیکیه، ولی ممکنه برای بعضی از نظر یادگیری مفید باشه. (امیدوارم باشه! 😅)
				برای همین پروژه رو تماما بصورت متن‌باز روی گیت‌هاب منتشر کردم تا همه بتونن کدهاش رو ببینن، و اگه ایرادی داشت بهم بگن تا کدهاش رو بهبود بدم.
				"""
			)
			
			mainStackView.addArrangedSubview(aboutAppSection)
			mainStackView.addArrangedSubview(makeDividerView())
			
			let projectGithubButton = makeButton(
				title: "گیت‌هاب پروژه",
				titleColor: .systemBackground,
				backgroundColor: .label) { [unowned self] in
				self.router.openURL(URL(string: V.Constants.appDownloadLink)!)
			}
			
			mainStackView.addArrangedSubview(iLoveOpenSource)
			mainStackView.addArrangedSubview(projectGithubButton)
			mainStackView.addArrangedSubview(makeDividerView())
			
			let contactMeTitle = makeTitleLabel(text: "ارتباط با من")
			let linkedInButton = makeButton(
				title: SocialNetwork.linkedIn.name,
				titleColor: .white,
				backgroundColor: SocialNetwork.linkedIn.color) { [unowned self] in
				self.router.openURL(SocialNetwork.linkedIn.link)
			}
			let githubButton = makeButton(
				title: SocialNetwork.github.name,
				titleColor: .systemBackground,
				backgroundColor: SocialNetwork.github.color) { [unowned self] in
				self.router.openURL(SocialNetwork.github.link)
			}
			
			let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 8)
			stackView.addArrangedSubviews(linkedInButton, githubButton)
			
			mainStackView.addArrangedSubview(contactMeTitle)
			mainStackView.addArrangedSubview(stackView)
			mainStackView.setCustomSpacing(8, after: stackView)
			
			let emptyView = UIView() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.snp.makeConstraints { (maker) in
					maker.height.equalTo(50)
				}
			}
			mainStackView.addArrangedSubview(emptyView)
		}
		
		private func setupMainContainerViews() {
			view.addSubview(scrollView) { (maker) in
				maker.top.equalTo(view)
				maker.leading.equalTo(view)
				maker.trailing.equalTo(view)
				maker.bottom.equalTo(view)
			}
			
			scrollView.addSubview(mainView) { (maker) in
				maker.top.equalTo(scrollView)
				maker.leading.equalTo(scrollView)
				maker.trailing.equalTo(scrollView)
				maker.bottom.equalTo(scrollView)
				maker.height.lessThanOrEqualTo(view).priority(.low)
				maker.width.equalTo(view)
			}
			
			mainView.addSubview(mainStackView) { (maker) in
				maker.top.equalTo(mainView)
				maker.leading.equalTo(mainView)
				maker.trailing.equalTo(mainView)
				maker.bottom.equalTo(mainView)
			}
		}
		
		// MARK: - View Makers
		
		private func makeTextsView(title: String, text: String) -> UIView {
			let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 8)
			stackView.addArrangedSubviews(
				makeTitleLabel(text: title),
				makeTextLabel(text: text)
			)
			
			let containerView = UIView() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
			}
			containerView.addSubview(stackView) { (maker) in
				maker.edges.equalToSuperview()
			}
			
			return containerView
		}
		
		private func makeTitleLabel(text: String) -> UILabel {
			return UILabel() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.numberOfLines = 0
				$0.textColor = .label
				$0.textAlignment = .right
				$0.font = .pinar(size: 20, weight: .bold)
				$0.text = text
			}
		}
		
		private func makeTextLabel(text: String) -> UILabel {
			return UILabel() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.numberOfLines = 0
				$0.textColor = .label
				$0.textAlignment = .right
				$0.font = .pinar(size: 15, weight: .regular)
				$0.text = text
			}
		}
		
		private func makeButton(
			title: String,
			titleColor: UIColor,
			backgroundColor: UIColor,
			handler: @escaping () -> Void
		) -> UIButton {
			let button = UIButton() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.setTitle(title, for: .normal)
				$0.setTitleColor(titleColor, for: .normal)
				$0.setCornerRadius(10)
				$0.titleLabel?.font = .pinar(size: 16, weight: .semibold)
				$0.backgroundColor = backgroundColor
				$0.snp.makeConstraints { (maker) in
					maker.height.equalTo(52)
				}
			}
			
			button
				.tapPublisher
				.sink(receiveValue: handler)
				.store(in: &cancellables)
			
			return button
		}
		
		private func makeDividerView() -> UIView {
			return UIView() .. {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.backgroundColor = UIColor { (traitCollection) -> UIColor in
					switch traitCollection.userInterfaceStyle {
					case .dark:
						return .systemGray5
					case .light,
						 .unspecified:
						return .systemGray6
					@unknown default:
						return .systemGray6
					}
				}
				$0.snp.makeConstraints { (maker) in
					maker.height.equalTo(1)
				}
			}
		}
		
	}
	
}


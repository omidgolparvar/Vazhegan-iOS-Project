//

import UIKit

protocol SceneRouter {
	associatedtype DataProvider
	
	var sourceController: UIViewController? { get set }
	var dataProvider: DataProvider? { get set }
	
	init()
}

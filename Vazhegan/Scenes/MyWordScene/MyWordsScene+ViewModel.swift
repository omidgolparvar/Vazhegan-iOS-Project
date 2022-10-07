//

import Foundation
import Combine
import VazheganFramework

extension MyWordsScene {
	
	final class ViewModel: SceneViewModel {
		private var cancellables = Set<AnyCancellable>()
		private let wordManager: WordManager
		
		@Published var sortOption: SortOption = .date
		@Published private(set) var myWords: [Word] = []
		
		init(wordManager: WordManager) {
			self.wordManager = wordManager
			setupBindings()
		}
		
		private func setupBindings() {
			$sortOption
				.removeDuplicates()
				.map { [unowned self] option in
					let myWords = self.wordManager.getMyWords().map(wordManager.copyWord(of:))
					
					switch option {
					case .date:
						return myWords
					case .title:
						return myWords.sorted(by: \.nonEmptyTitle)
					}
				}
				.assign(to: &$myWords)
		}
		
		func removeWord(at index: Int) {
			let word = myWords.remove(at: index)
			wordManager.removeWordFromMyWords(word)
		}
		
		func removeWord(_ word: Word) {
			guard let index = myWords.firstIndex(of: word) else { return }
			removeWord(at: index)
		}
		
		enum SortOption: CaseIterable {
			case title
			case date
			
			var name: String {
				switch self {
				case .title:
					return "عنوان"
				case .date:
					return "تاریخ ذخیره"
				}
			}
		}
		
	}
	
}

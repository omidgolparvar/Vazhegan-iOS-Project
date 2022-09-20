//

import Foundation
import Combine
import VazheganFramework

extension MyWordsScene {
	
	final class ViewModel: SceneViewModel {
		private let wordManager: WordManager
		
		@Published private(set) var myWords: [Word]
		
		init(wordManager: WordManager) {
			self.wordManager = wordManager
			self.myWords = wordManager.getMyWords().map(wordManager.copyWord(of:))
		}
		
		func removeWord(at index: Int) {
			let word = myWords.remove(at: index)
			wordManager.removeWordFromMyWords(word)
		}
		
		func removeWord(_ word: Word) {
			guard let index = myWords.firstIndex(of: word) else { return }
			removeWord(at: index)
		}
		
	}
	
}

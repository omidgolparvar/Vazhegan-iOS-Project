//

import Foundation
import Combine
import VazheganFramework

extension WordScene {
	
	final class ViewModel: SceneViewModel {
		
		private var getMeaningCancellable: AnyCancellable?
		private let networkManager: NetworkManager
		private let wordManager: WordManager
		let originalWord: Word
		
		@Published private(set) var getMeaningStatus = GetMeaningStatus.notRequested
		@Published private(set) var isWordFavorited: Bool
		
		var shareText: String? {
			guard case .success(let word) = getMeaningStatus else { return nil }
			let text = "📱 واژگان"
				+ "\n\n" + "\(word.nonEmptyTitle) (\(word.database.name))"
				+ "\n\n" + "\(word.fullText)"
				+ "\n\n" + V.Constants.appDownloadLink
			
			return text
		}
		
		init(
			word: Word,
			networkManager: NetworkManager,
			wordManager: WordManager
		) {
			self.originalWord = word
			self.networkManager = networkManager
			self.wordManager = wordManager
			self.isWordFavorited = wordManager.isWordInMyWords(word)
		}
		
		func getMeaning() {
			if originalWord.hasFullMeaning {
				getMeaningStatus = .success(originalWord)
				return
			}
			
			getMeaningCancellable?.cancel()
			getMeaningStatus = .loading(originalWord)
			getMeaningCancellable = networkManager
				.getMeaning(of: originalWord)
				.sink(receiveCompletion: { [weak self] (completion) in
					guard let self = self else { return }
					
					switch completion {
					case .failure(let error):
						self.getMeaningStatus = .failed(error)
					case .finished:
						break
					}
				}, receiveValue: { [weak self] (word) in
					guard let self = self else { return }
					
					self.getMeaningStatus = .success(word)
				})
		}
		
		func cancelSearch() {
			getMeaningCancellable?.cancel()
		}
		
		func toggleIsFavoriteStatus() {
			guard case .success(let word) = getMeaningStatus else { return }
			let copyOfWord = wordManager.copyWord(of: word)
			
			if isWordFavorited {
				wordManager.removeWordFromMyWords(copyOfWord)
			} else {
				wordManager.setTexts(for: copyOfWord, basedOn: originalWord)
				wordManager.addWordToMyWords(copyOfWord)
			}
			
			isWordFavorited.toggle()
		}
	}
	
	enum GetMeaningStatus {
		case notRequested
		case loading(Word)
		case success(Word)
		case failed(Error)
	}
	
}

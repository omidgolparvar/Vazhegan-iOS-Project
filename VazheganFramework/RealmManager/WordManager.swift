import Foundation

public protocol WordManager {
	func getMyWords() -> [Word]
	func deleteWord(_ word: Word)
	func copyWord(of word: Word) -> Word
	func setTexts(for word: Word, basedOn anotherWord: Word)
	func isWordInMyWords(_ word: Word) -> Bool
	func addWordToMyWords(_ word: Word)
	func removeWordFromMyWords(_ word: Word)
	func database(for word: Word) -> Database
}

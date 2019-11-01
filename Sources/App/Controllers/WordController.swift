import Foundation
import Vapor
import Fluent
import FluentMySQL
import Crypto
import Authentication

final class WordController: RouteCollection {
	
	func boot(router: Router) throws {
		let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let basicAuthGroup = router.grouped([basicAuthMiddleware, guardAuthMiddleware])
		
		let wordRoutes = router.grouped("api", "word")
		let wordOfTheDayRoutes = router.grouped("api", "wordOfTheDay")
		
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let tokenProtected = router.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		wordRoutes.get(use: index)
        wordOfTheDayRoutes.get("api/word", Word.parameter, use: fetch)
		tokenProtected.patch("api/word", Word.parameter, use: update)
		tokenProtected.delete("api/word", Int.parameter, use: delete)
		wordRoutes.post(Word.self, use: create)
	}
	
	func index(_ req: Request) throws -> Future<[Word]> {
		return Word
			.query(on: req)
			.all()
	}
	
	func create(_ req: Request, newWord: Word) throws -> Future<HTTPResponseStatus> {
		return try Word.query(on: req).filter(\.word == newWord.word).first().flatMap { existingWord in
			guard existingWord == nil else {
				throw Abort(.badRequest, reason: "This word already exists", identifier: nil)
			}
			let persisterWord = Word(id: nil, word: newWord.word, definition: newWord.definition, synonyms: newWord.synonyms, usage: newWord.usage, selected: newWord.selected, wordOfTheDay: false, date: "")
			return persisterWord.save(on: req).transform(to: .created)
		}
	}
	
	func update(_ req: Request) throws -> Future<Word> {
		return try req.parameters.next(Word.self).flatMap { word in
			return try req.content.decode(Word.self).flatMap { newWord in
				word.selected = newWord.selected
				return word.save(on: req)
			}
		}
	}
	
	func fetch(_ req: Request) throws -> Future<Word> {
		var useCurrentWord = false;
        // TODO fux this random call
		let randomNum = Int.random(in: 1 ..< 2)
		let wordOfTheDay : EventLoopFuture<Word?> = Word.query(on: req).filter(\.wordOfTheDay == true).first().map {
			existingWord in
			if let word = existingWord {
                if word.date == Date.todaysDateAsString() {
					useCurrentWord = true
				}
			}
			return existingWord
		}
		if useCurrentWord {
			return wordOfTheDay.unwrap(or: Abort(.badRequest, reason: "Can't find word of the day", identifier: nil))
		} else {
			let newWordOfTheDay = Word.find(randomNum, on: req)
			updateTheWordOfTheDay(wordOfTheDay, newWordOfTheDay, req)
			return newWordOfTheDay.unwrap(or: Abort(.badRequest, reason: "Can't find word of the day", identifier: nil))
		}
	}
	
	func updateTheWordOfTheDay(_ lastWord: EventLoopFuture<Word?>, _ currentWord: EventLoopFuture<Word?>, _ req: Request) {
		let _ : EventLoopFuture<Word?> = lastWord.map {
			word in
			if let priorWord = word {
				priorWord.wordOfTheDay = false
				priorWord.date = ""
				priorWord.save(on: req)
				
			}
			return word
		}
		let _ : EventLoopFuture<Word?> = currentWord.map {
			word in
			if let nextWord = word {
				nextWord.wordOfTheDay = true
				nextWord.date = self.getDateAsString()
				nextWord.save(on: req)
			}
			return word
		}
	}
	
	func delete(_ req: Request) throws -> Future<Word> {
		let wordId = try req.parameters.next(Int.self)
		return Word
			.find(wordId, on: req)
			.unwrap(or: Abort(.notFound))
			.delete(on: req)
	}
}

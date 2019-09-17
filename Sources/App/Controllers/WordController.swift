import Foundation
import Vapor
import Fluent
import FluentMySQL
import Crypto
import Authentication

/// Controls basic CRUD operations on `Todo`s.
final class WordController: RouteCollection {
	
	func boot(router: Router) throws {
		let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let basicAuthGroup = router.grouped([basicAuthMiddleware, guardAuthMiddleware])
		
		let wordRoutes = router.grouped("api", "word")
		
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let tokenProtected = router.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		wordRoutes.get(use: index)
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
			let persisterWord = Word(id: nil, word: newWord.word, definition: newWord.definition, synonyms: newWord.synonyms, usage: newWord.usage, selected: newWord.selected)
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
	
	func delete(_ req: Request) throws -> Future<Word> {
		let wordId = try req.parameters.next(Int.self)
		return Word
			.find(wordId, on: req)
			.unwrap(or: Abort(.notFound))
			.delete(on: req)
	}
}

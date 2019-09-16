import Foundation
import Vapor
import Fluent
import FluentMySQL

/// Controls basic CRUD operations on `Todo`s.
final class WordController: RouteCollection {
	
	func boot(router: Router) throws {
		let wordRoutes = router.grouped("api", "word")
		wordRoutes.get(use: index)
		wordRoutes.patch(Int.parameter, use: update)
		wordRoutes.delete(Int.parameter, use: delete)
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
		let wordId = try req.parameters.next(Int.self)
		return Word
		.find(wordId, on: req)
		.unwrap(or: Abort(.notFound))
		.flatMap(to: Word.self) { word in
			return word.update(on: req)
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

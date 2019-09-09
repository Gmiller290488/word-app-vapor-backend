import FluentMySQL
import Vapor

final class Word: Codable {
	
    var id: Int?
    var word: String
	var definition: String

	init(id: Int? = nil, word: String, definition: String) {
        self.id = id
        self.word = word
		self.definition = definition
    }
}

extension Word: MySQLModel { }
extension Word: Migration { }
extension Word: Content { }
extension Word: Parameter { }

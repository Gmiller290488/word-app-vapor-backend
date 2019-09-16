import FluentMySQL
import Vapor

final class Word: Codable {
	
    var id: Int?
    var word: String
	var definition: String
	var usage: String
	var synonyms: String
	var selected: Int

	init(id: Int? = nil, word: String, definition: String, synonyms: String, usage: String, selected: Int) {
        self.id = id
        self.word = word
		self.definition = definition
		self.selected = selected
		self.usage = usage
		self.synonyms = synonyms
    }
}

extension Word: MySQLModel { }
extension Word: Migration { }
extension Word: Content { }
extension Word: Parameter { }

import FluentMySQL
import Vapor
import Authentication

final class Word: Codable {
	
    var id: Int?
    var word: String
	var definition: String
	var usage: String
	var synonyms: String
	var selected: Bool
	var wordOfTheDay: Bool
	var date: String

	init(id: Int? = nil,
		 word: String,
		 definition: String,
		 synonyms: String,
		 usage: String,
		 selected: Bool,
		 wordOfTheDay: Bool,
		 date: String) {
        self.id = id
        self.word = word
		self.definition = definition
		self.selected = selected
		self.usage = usage
		self.synonyms = synonyms
		self.wordOfTheDay = wordOfTheDay
		self.date = date
    }
}

extension Word: MySQLModel { }
extension Word: Migration { }
extension Word: Content { }
extension Word: Parameter { }

//extension Word: TokenAuthenticatable {
//	typealias TokenType = Token
//}

//
//  Token.swift
//  App
//
//  Created by Gareth Miller on 17/09/2019.
//

import Foundation
import Vapor
import FluentMySQL
import Authentication

final class Token: Codable {
	var id: Int?
	var token: String
	var userID: User.ID

	init(token: String, userID: User.ID) {
		self.token = token
		self.userID = userID
	}
}

extension Token: MySQLModel {}
extension Token: Migration {}
extension Token: Content {}

extension Token {
	static func generate(for user: User) throws -> Token {
		let random = try CryptoRandom().generateData(count: 16)
		return try Token(token: random.base64EncodedString(), userID: user.requireID())
	}
}

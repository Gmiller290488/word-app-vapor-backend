//
//  User.swift
//  App
//
//  Created by Gareth Miller on 16/09/2019.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL
import Authentication

final class User: MySQLModel {
	
	var id: Int?
	private(set) var email: String
	private(set) var password: String
	
	init(email: String, password: String) {

		self.email = email
		self.password = password
	}
}

extension User: BasicAuthenticatable {
	static let usernameKey: WritableKeyPath<User, String> = \.email
	static let passwordKey: WritableKeyPath<User, String> = \.password
}

extension User: Parameter {}
extension User: Migration {}
extension User: Content {}

extension User: TokenAuthenticatable {
	typealias TokenType = Token
}

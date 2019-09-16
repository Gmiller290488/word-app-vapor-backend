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

struct User: Content, MySQLUUIDModel, Migration {
	
	var id: UUID?
	private(set) var email: String
	private(set) var password: String
}

extension User: BasicAuthenticatable {
	static let usernameKey: WritableKeyPath<User, String> = \.email
	static let passwordKey: WritableKeyPath<User, String> = \.password
}

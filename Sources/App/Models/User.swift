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
import LocalAuthentication

struct User: Content, MySQLUUIDModel, Migration {
	
	var id: UUID?
	private(set) var email: String
	private(set) var password: String
}

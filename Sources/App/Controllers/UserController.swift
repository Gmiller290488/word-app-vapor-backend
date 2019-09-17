//
//  UserController.swift
//  App
//
//  Created by Gareth Miller on 16/09/2019.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL
import Crypto

class UserController: RouteCollection {
	
	func boot(router: Router) throws {
		let group = router.grouped("api", "users")
		let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let basicProtected = group.grouped(basicAuthMiddleware, guardAuthMiddleware)
		group.post(User.self, at: "register", use: registerUserHandler)
		basicProtected.post("login", use: loginHandler)
	}
}

private extension UserController {
	
	func registerUserHandler(_ request: Request, newUser: User) throws -> Future<HTTPResponseStatus> {
		return try User.query(on: request).filter(\.email == newUser.email).first().flatMap { existingUser in
			guard existingUser == nil else {
				throw Abort(.badRequest, reason: "a user with this email already exists", identifier: nil)
			}
			
			let digest = try request.make(BCryptDigest.self)
			let hashedPassword = try digest.hash(newUser.password)
			let persistedUser = User(email: newUser.email, password: hashedPassword)
			
			return persistedUser.save(on: request).transform(to: .created)
		}
	}
	
	func loginHandler(_ req: Request) throws -> Future<Token> {
		let user = try req.requireAuthenticated(User.self)
		let token = try Token.generate(for: user)
		return token.save(on: req)
	}
}

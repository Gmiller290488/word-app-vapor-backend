import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
	let wordRouteController = WordController()
	try wordRouteController.boot(router: router)
	
	let userRouteController = UserController()
	try userRouteController.boot(router: router)
}

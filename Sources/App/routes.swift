import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
	let wordRouteController = WordController()
	try router.register(collection: wordRouteController)
	
	let userRouteControler = UserController()
	try router.register(collection: userRouteControler)
}

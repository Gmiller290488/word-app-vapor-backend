import FluentMySQL
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
	
	let router = EngineRouter.default()
	try routes(router)
	services.register(router, as: Router.self)

	let directoryConfig = DirectoryConfig.detect()
	services.register(directoryConfig)
	
	try services.register(FluentMySQLProvider())
	try services.register(AuthenticationProvider())

    // Configure a SQLite database
	var databases = DatabasesConfig()
	let databaseConfig = MySQLDatabaseConfig(
		hostname: Environment.get("DB_HOSTNAME")!,
		username: Environment.get("DB_USER")!,
		password: Environment.get("DB_PASSWORD")!,
		database: Environment.get("DB_DATABASE")!
	)
	
	let database = MySQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .mysql)
    services.register(database)

    // Configure migrations
    var migrations = MigrationConfig()
	migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Word.self, database: .mysql)
    services.register(migrations)
}

import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    let dbHostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let dbAccount = Environment.get("DATABASE_USERNAME") ?? "vapor_username"
    let dbConfig = SQLPostgresConfiguration(hostname: dbHostname, username: dbAccount, tls: .disable)
    app.databases.use(.postgres(configuration: dbConfig, sqlLogLevel: .debug), as: .psql)
    // register routes
    try routes(app)
}

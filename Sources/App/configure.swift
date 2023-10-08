import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) async throws {
    let dbHostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let dbAccount = Environment.get("DATABASE_USERNAME") ?? "aermoshin"
    let dbConfig = SQLPostgresConfiguration(hostname: dbHostname, username: dbAccount, tls: .disable)
    app.databases.use(.postgres(configuration: dbConfig, sqlLogLevel: .debug), as: .psql)
    
    try await app.db.schema("tabs")
        .id()
        .field("left_tab_id", .uuid)
        .field("right_tab_id", .uuid)
        .field("updated", .date)
        .field("host", .string)
        .field("path", .string)
        .ignoreExisting()
        .create()
    
    app.logger.logLevel = .debug
    app.http.server.configuration.supportVersions = [.one]
    app.http.server.configuration.hostname = Environment.get("COTTON_HOSTNAME") ?? "127.0.0.1"
    /// Can't set other port number because need to have some permissions
    app.http.server.configuration.port = 8080
    
    /**
     TODO:  HTTPS
     app.http.server.configuration.tlsConfiguration?.minimumTLSVersion = .tlsv13
     app.http.server.configuration.port = 443
     let privateKey: NIOSSLPrivateKeySource = .file("cotton_private_key")
     try app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(certificateChain: [], privateKey: privateKey)
     */
    
    try routes(app)
}

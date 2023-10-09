import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) async throws {
    let dbHostname = Environment.get("DB_HOSTNAME") ?? "localhost"
    let dbAccount = Environment.get("DB_USERNAME") ?? "postgres"
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
    app.http.server.configuration.hostname = Environment.get("COTTON_HOSTNAME") ?? "localhost"
    
    /// Config HTTPS
    app.http.server.configuration.port = 443
    let privateKey: NIOSSLPrivateKeySource = .file("localhost+1-key.pem")
    let sslPemCertChain = try NIOSSLCertificate.fromPEMFile("localhost+1.pem")
    let certSources: [NIOSSLCertificateSource] = sslPemCertChain.map { .certificate($0) }
    var tlsConfig: TLSConfiguration = .makeServerConfiguration(certificateChain: certSources,
                                                               privateKey: privateKey)
    tlsConfig.minimumTLSVersion = .tlsv13
    app.http.server.configuration.tlsConfiguration = tlsConfig
    
    try routes(app)
}

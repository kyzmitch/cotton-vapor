import Vapor
import Fluent
import FluentPostgresDriver

class SslCertsReader {
    private init() {}
    
    static func readCerts() throws -> [NIOSSLCertificate] {
#if NIO_CERT_READ
        return try NIOSSLCertificate.fromPEMFile("localhost+1.pem")
#else
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "localhost+1", ofType: "pem") else {
            throw Abort(.custom(code: 512, reasonPhrase: "SSL certificates resource not found"))
        }
        guard FileManager.default.fileExists(atPath: path) else {
            throw Abort(.custom(code: 512, reasonPhrase: "SSL certificates file not found"))
        }
        guard FileManager.default.isReadableFile(atPath: path) else {
            throw Abort(.custom(code: 512, reasonPhrase: "No read permission for SSL certificates"))
        }
        guard let certData = FileManager.default.contents(atPath: path) else {
            throw Abort(.custom(code: 512, reasonPhrase: "SSL certificates file data fail"))
        }
        
        return try NIOSSLCertificate.fromPEMBytes(certData.base32Bytes())
#endif
    }
}

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
    let sslPemCertChain: [NIOSSLCertificate] = try SslCertsReader.readCerts()
    let certSources: [NIOSSLCertificateSource] = sslPemCertChain.map { .certificate($0) }
    var tlsConfig: TLSConfiguration = .makeServerConfiguration(certificateChain: certSources,
                                                               privateKey: privateKey)
    tlsConfig.minimumTLSVersion = .tlsv13
    app.http.server.configuration.tlsConfiguration = tlsConfig
    
    try routes(app)
}

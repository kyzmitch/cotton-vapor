//
//  File.swift
//  
//
//  Created by Andrei Ermoshin on 10/5/23.
//

import Vapor

struct TabsController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let tabs = routes.grouped("tabs")
        tabs.get(use: handleFetchAll)
        tabs.post(use: handleCreateTab)
        tabs.delete(":id", use: handleTabDelete)
        tabs.put("changelog", use: handleTabsChangelog)
    }
}

private extension TabsController {
    // MARK: - fetch all
    
    func handleFetchAll(_ req: Request) async throws -> [api.Tab] {
        /// If we assume that one single db table is used for all users
        /// then we have to query tab records only for that specific user id
        let dbTabs = try await db.Tab.query(on: req.db).all()
        let tabs = dbTabs.compactMap { $0.pubValue }
        guard tabs.count == dbTabs.count else {
            throw Abort(.internalServerError)
        }
        return tabs
    }
    
    // MARK: - create tab
    
    func handleCreateTab(_ req: Request) async throws -> String {
        let content = try req.content.decode(api.Tab.Content.self)
        let tabId = UUID()
        let tab = api.Tab(tabId, content)
        let dbTab = db.Tab(tab)
        try await dbTab.create(on: req.db)
        return tabId.uuidString
    }
    
    // MARK: delete tab
    
    func handleTabDelete(_ req: Request) async throws -> String {
        guard let tabId = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        guard let record = try await db.Tab
            .query(on: req.db)
            .filter(.id, .equality(inverse: false), tabId)
            .first() else {
            throw Abort(.notFound)
        }
        try await record.delete(on: req.db)
        return tabId
    }
    
    // MARK: - batch tabs update
    
    func handleTabsChangelog(_ req: Request) async throws -> String {
        /// e.g. after client became online and need to sync a lot of tabs changes
        return ""
    }
}

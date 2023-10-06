import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: TabsController())
    
    let tabs = app.grouped("tabs")
    tabs.get { req async throws in
        /// If we assume that one single db table is used for all users
        /// then we have to query tab records only for that specific user id
        let dbTabs = try await db.Tab.query(on: req.db).all()
        let tabs = dbTabs.compactMap { $0.pubValue }
        guard tabs.count == dbTabs.count else {
            throw Abort(.internalServerError)
        }
        return try await tabs.encodeResponse(for: req)
    }.description(.fetchAllTabs)

    tabs.put("changelog") { req in
        /// Possibly would be not a bad idea
        /// to do tabs batch sync and not many single rest requests.
        "Added/updated/deleted tabs"
    }.description(.updateTabsChangelog)
}

private extension String {
    static let fetchAllTabs = "Fetch all tabs"
    static let createTab = "Add one tab"
    static let deleteTab = "Delete single tab"
    static let updateTabsChangelog = "Update tabs state - add,update or remove"
}

import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: TabsController())
    
    let tabs = app.grouped("tabs")
    tabs.get { req async -> String in
        /// Response perhaps should be an ordered array with tab objects
        /// maybe sorting is better to be done on client side to not waste backend computing resources
        "All tabs for specific user"
    }.description(.fetchAllTabs)
    tabs.post { req in
        let content = try req.content.decode(api.Tab.Content.self)
        let id = UUID()
        _ = api.Tab(id: id, content: content)
        /// TODO: record in DB
        return id.uuidString
    }.description(.createTab)
    tabs.delete(":tab_id") { req in
        guard let tabId = req.parameters.get("tab_id") else {
            throw Abort(.badRequest)
        }
        return tabId
    }.description(.deleteTab)
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

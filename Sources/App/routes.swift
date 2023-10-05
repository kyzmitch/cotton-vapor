import Vapor

extension String {
    static let fetchAllTabs = "Fetch all tabs"
    static let createTab = "Add one tab"
    static let deleteTab = "Delete single tab"
    static let updateTabsChangelog = "Update tabs state - add,update or remove"
}

func routes(_ app: Application) throws {
    try app.register(collection: TabsController())
    
    let tabs = app.grouped("tabs")
    tabs.get { req async -> String in
        /// Response perhaps should be an ordered array with tab objects
        /// maybe sorting is better to be done on client side to not waste backend computing resources
        "All tabs for specific user"
    }.description(.fetchAllTabs)
    tabs.post { req in
        /// Post response should perhaps contain some unique identifier of tab object
        /// record from database
        "Tab was added"
    }.description(.createTab)
    tabs.delete(":tab_id") { req in
        /// For delete response it would be better to use Void or (), but
        /// Vapor requires the response type to confirm to `ResponseEncodable`
        "Tab deleted"
    }.description(.deleteTab)
    tabs.put("changelog") { req in
        /// Possibly would be not a bad idea
        /// to do tabs batch sync and not many single rest requests.
        "Added/updated/deleted tabs"
    }.description(.updateTabsChangelog)
}

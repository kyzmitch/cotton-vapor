import Vapor

func routes(_ app: Application) throws {
    app.get("tabs") { req async -> String in
        /// Response perhaps should be an ordered array with tab objects
        /// maybe sorting is better to be done on client side to not waste backend resources
        "All tabs for specific user"
    }
    app.on(.POST, "tab") { req in
        /// Post response should perhaps contain some unique identifier of tab object
        /// record from database
        "Tab was added"
    }
    app.delete("tab") { req in
        /// For delete response it would be better to use Void or (), but
        /// Vapor requires the response type to confirm to `ResponseEncodable`
        "Tab deleted"
    }
    app.put("tabs", "changelog") { req in
        /// Possibly would be not a bad idea
        /// to do tabs batch sync and not many single rest requests.
        "Added/updated/deleted tabs"
    }
}

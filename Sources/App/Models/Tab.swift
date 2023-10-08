//
//  File.swift
//  
//
//  Created by Andrei Ermoshin on 10/5/23.
//

import Vapor
import Fluent

extension api {
    /// Data type which should represent user tab to sync
    struct Tab: Content {
        /// Data type which should represent Tab's content without id
        /// because client can't create identifier
        struct Content: Vapor.Content {
            /// hostname in URL
            let host: String
            /// site path in URL
            let path: String
            /// An id of the tab from the left to maintain user tabs ordering and ability to move tab for the user.
            /// Could be nil if current tab doesn't have any neighbour tabs on the left.
            let leftTab: UUID?
            /// An id of the tab from the right to maintain user tabs ordering and ability to move tab for the user
            /// Could be nil if current tab doesn't have any neighbour tabs on the right.
            let rightTab: UUID?
            
            init(_ host: String, _ path: String, _ leftTab: UUID?, _ rightTab: UUID?) {
                self.host = host
                self.path = path
                self.leftTab = leftTab
                self.rightTab = rightTab
            }
        }
        
        /// Tab's identifier on backend side, which can only be created on the backend
        let id: UUID
        /// Tab's site content, should be separate type, because client is not creating id for the tab
        let content: Content
        
        init(_ id: UUID, _ content: Content) {
            self.id = id
            self.content = content
        }
    }
}

extension db {
    /// Tab data type for internal use in database
    final class Tab: Model {
        /// Have to use invalid constructor due to Vapor's architecture
        init() {}
        
        typealias IDValue = UUID
        static let schema: String = "tabs"
        
        @ID var id: UUID?
        @Field(key: "host") var host: String
        @Field(key: "path") var path: String
        @Field(key: "left_tab_id") var leftTab: UUID?
        @Field(key: "right_tab_id") var rightTab: UUID?
        
        init(_ value: api.Tab) {
            id = value.id
            leftTab = value.content.leftTab
            rightTab = value.content.rightTab
            host = value.content.host
            path = value.content.path
        }
        
        var pubValue: api.Tab? {
            guard let identifier = id else {
                return nil
            }
            let content = api.Tab.Content(host, path, leftTab, rightTab)
            return api.Tab(identifier, content)
        }
    }
}

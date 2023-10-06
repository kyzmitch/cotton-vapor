//
//  File.swift
//  
//
//  Created by Andrei Ermoshin on 10/5/23.
//

import Vapor
import Fluent

extension api {
    struct Tab: Content {
        let id: UUID
        struct Content: Vapor.Content {
            let host: String
            let path: String
        }
        let content: Content
    }
}

extension db {
    final class Tab: Model {
        init() {}
        
        typealias IDValue = UUID
        static let schema: String = "tabs"
        
        @ID
        var id: UUID?
        @Field(key: "content")
        var content: api.Tab.Content
        
        init(_ value: api.Tab) {
            id = value.id
            content = value.content
        }
        
        var pubValue: api.Tab? {
            guard let identifier = id else {
                return nil
            }
            return api.Tab(id: identifier, content: content)
        }
    }
}

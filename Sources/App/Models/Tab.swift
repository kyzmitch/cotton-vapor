//
//  File.swift
//  
//
//  Created by Andrei Ermoshin on 10/5/23.
//

import Vapor

struct Tab: Identifiable, Content {
    /// Tab's site content data.
    /// Always https, so, not storing scheme type
    struct Content: Codable {
        let host: String
        let path: String
    }
    
    let id: UUID
    let content: Content
}

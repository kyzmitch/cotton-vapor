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
    }
}

private extension TabsController {
    // MARK: - fetch all
    
    func handleFetchAll(_ req: Request) async throws -> [api.Tab] {
        
        return []
    }
}

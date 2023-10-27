//
//  File.swift
//  
//
//  Created by Andrei Ermoshin on 10/9/23.
//

import Foundation
import PackagePlugin

@main
struct CopySSLCertificates: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        /// TBD, generate some swift files, maybe mocks
        return []
    }
}

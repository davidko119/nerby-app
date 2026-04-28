//
//  nerby_appApp.swift
//  nerby app
//
//  Created by office on 28/04/2026.
//

import SwiftUI

@main
struct nerby_appApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}

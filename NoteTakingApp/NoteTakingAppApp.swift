//
//  NoteTakingAppApp.swift
//  NoteTakingApp
//
//  Created by Brandon Baker on 2/3/26.
//

import SwiftUI

// This is the main starting point of the app
// SwiftUI runs this file first when the app launches
@main
struct NoteTakingAppApp: App {
    var body: some Scene {
        
        // WindowGroup sets up the main app window
        // ContentView is the first screen the user sees
        WindowGroup {
            ContentView()
        }
    }
}

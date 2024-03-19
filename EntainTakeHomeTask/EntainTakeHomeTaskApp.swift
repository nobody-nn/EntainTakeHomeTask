//
//  EntainTakeHomeTaskApp.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import SwiftUI

@main
struct EntainTakeHomeTaskApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
        }
    }
}

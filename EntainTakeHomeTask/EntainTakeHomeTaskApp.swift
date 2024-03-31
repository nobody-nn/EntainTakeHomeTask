//
//  EntainTakeHomeTaskApp.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import SwiftUI
import TipKit

@main
struct EntainTakeHomeTaskApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if #available(iOS 17.0, *) {
                        try? Tips.configure()
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .environmentObject(networkMonitor)
        }
    }
}

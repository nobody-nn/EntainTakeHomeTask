//
//  ContentView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NextToGoView()
                .tabItem {
                    Symbols.race
                    Text("Next")
                }
            SettingView()
                .tabItem {
                    Symbols.Setting
                    Text("Setting")
                }
        }
    }
}

#Preview {
    ContentView()
}

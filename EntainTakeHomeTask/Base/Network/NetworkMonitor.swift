//
//  NetworkMonitor.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/18.
//

import SwiftUI
import Network

// @Observable(iOS 17)
final class NetworkMonitor: ObservableObject {
    @Published var hasNetworkConnection = true
    
    private let networkMonitor = NWPathMonitor()
    
    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                print("network status changed:\(path.status)")
                self?.hasNetworkConnection = path.status == .satisfied
            }
        }
        
        networkMonitor.start(queue: DispatchQueue.global())
    }
}

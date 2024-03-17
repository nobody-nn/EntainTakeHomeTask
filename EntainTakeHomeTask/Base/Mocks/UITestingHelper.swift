//
//  UITestingHelper.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/15.
//

#if DEBUG

import Foundation

struct UITestingHelper {
    
    /// If it's in UITesting mode
    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui-testing")
    }
    
    /// If we need the success version
    static var isNextToGoNetworkSuccessful: Bool {
        ProcessInfo.processInfo.environment["-next-to-go-network-success"] == "1"
    }
    
    /// specific error for failure network
    static var nextToGoNetworkError: NetworkRequestError? {
        let statusCode: String? = ProcessInfo.processInfo.environment["-next-to-go-fail_status"]
        let error = CombineNetworkManager.shared.handleURLResponseError(Int(statusCode ?? "0")!)
        return error
    }
}

#endif

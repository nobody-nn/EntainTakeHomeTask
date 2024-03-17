//
//  Endpoint.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

import Foundation

/// https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10
enum Endpoint {
    case NextToGo(method: String, count: Int)
}

/// Http request type
extension Endpoint {
    enum MethodType: Equatable {
        case GET
        case POST(data: Data?)
    }
}

extension Endpoint {
    
    var host: String { "api.neds.com.au" }
    
    var path: String {
        switch self {
        case .NextToGo:
            return "/rest/v1/racing/"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .NextToGo:
            return .GET
        }
    }
    
    /// config all request parameters
    var queryItems: [String: String]? {
        switch self {
        case .NextToGo(let method, let count):
            return ["method":"\(method)", "count":"\(count)"]
        }
    }
}

extension Endpoint {
    
    /// Assemble url (before this, make sure all parameters have been set)
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}

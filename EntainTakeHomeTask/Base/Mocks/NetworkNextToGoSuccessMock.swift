//
//  NetworkNextToGoSuccessMock.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/15.
//
#if DEBUG

import Foundation
import Combine

/// mock success network, caller can set specific return data
class NetworkNextToGoSuccessMock: AnyNetworkManager {
    var nextToGoResult: AnyPublisher<NextToGoResponse, NetworkRequestError>?
    
    func fetchData<T>(urlSession: URLSession, _ endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, NetworkRequestError> where T : Decodable {
        // Return injected parameters first
        if nextToGoResult != nil {
            return nextToGoResult as! AnyPublisher<T, NetworkRequestError>
        } else {
            let nextToGoResponse = try! JSONMapper.decode(file: "NextToGoData", type: NextToGoResponse.self)
            return Result<T, NetworkRequestError>.Publisher(.success(nextToGoResponse as! T))
                .eraseToAnyPublisher()
        }
    }
}

#endif

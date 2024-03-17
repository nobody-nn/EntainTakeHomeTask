//
//  NetworkNextToGoFailureMock.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/15.
//

#if DEBUG

import Foundation
import Combine

/// mock failure network, caller can set specific error
class NetworkNextToGoFailureMock: AnyNetworkManager {
    // use injected error first
    var customError: NetworkRequestError?
    
    func fetchData<T>(urlSession: URLSession, _ endpoint: Endpoint, type: T.Type) throws -> AnyPublisher<T, NetworkRequestError> where T : Decodable {
        return Result<T, NetworkRequestError>.Publisher(.failure(customError ?? .badRequest))
            .eraseToAnyPublisher()
    }
}

#endif

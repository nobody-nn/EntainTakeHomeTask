//
//  NetworkManager.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import Foundation
import Combine

protocol AnyNetworkManager {
    /// Fetch data from server
    /// - Parameters:
    ///    - urlSession:
    ///    - endpoint: which kind of sever data
    ///    - type: the type of the response data
    /// - Returns: A publisher with response data or error
    func fetchData<T: Decodable>(urlSession: URLSession,
                                 _ endpoint: Endpoint,
                                 type: T.Type) throws -> AnyPublisher<T, NetworkRequestError>
}

final class CombineNetworkManager: AnyNetworkManager {

    // one instance
    static let shared = CombineNetworkManager()
    private init() {}
    
    /// Fetch data from server
    /// - Parameters:
    ///    - urlSession:
    ///    - endpoint: which kind of sever data
    ///    - type: the type of the response data
    /// - Returns: A publisher with response data or error
    func fetchData<T: Decodable>(urlSession: URLSession = .shared,
                                 _ endpoint: Endpoint,
                                 type:T.Type) throws -> AnyPublisher<T, NetworkRequestError> {
        
        guard let url = endpoint.url else {
            throw NetworkRequestError.invalidUrl
        }
        
        print("begin fetch server")
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap({ data, response in
                // If the response is invalid, throw an error
                guard let response = response as? HTTPURLResponse else {
                    throw self.handleURLResponseError(0)
                }
                
                // bad response
                if !(200...299).contains(response.statusCode) {
                    throw self.handleURLResponseError(response.statusCode)
                }
                // all good
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return self.handleURLSessionError(error)
            }
            .eraseToAnyPublisher()
    }
    
}


extension CombineNetworkManager {
    
    /// Parses HTTPURLResponse StatusCode error
    /// - Parameter statusCode: HTTPURLResponse status code
    /// - Returns: Readable NetworkRequestError
    func handleURLResponseError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...599: return .serverError(statusCode)
        default: return .unknownError
        }
    }
    
    /// Parses URLSession Publisher errors
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
    func handleURLSessionError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError(error.localizedDescription)
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
}

private extension CombineNetworkManager {
    /// Build request with url and methodType
    /// - Parameters:
    ///     - from: url
    ///     - methodType: GET, POST etc.
    /// - Returns: A URLRequest
    func buildRequest(from url: URL,
                      methodType: Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        }
        return request
    }
}

/// Server request relevant error
enum NetworkRequestError: LocalizedError, Equatable {
    case invalidUrl
    /// statusCode error
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError(_ code: Int)
    /// decode error
    case decodingError( _ description: String)
    /// URL error
    case urlSessionFailed(_ error: URLError)
    /// all other errors
    case unknownError
}

extension NetworkRequestError {
    
    /// Readable description
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL isn't valid"
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unauthorized request"
        case .forbidden:
            return "Forbidden to request"
        case .notFound:
            return "Source not found"
        case .serverError:
            return "server errors"
        case .decodingError:
            return "Failed to decode"
        case .urlSessionFailed, .unknownError:
            return "Something went wrong"
        }
    }
}

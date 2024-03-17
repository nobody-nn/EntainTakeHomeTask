//
//  NetworkManagerTests.swift
//  EntainTakeHomeTaskTests
//
//  Created by nana Zhang on 2024/3/15.
//

import XCTest
import Combine
@testable import EntainTakeHomeTask

final class NetworkManagerTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    func test_with_network_request() throws {
        let expectation = self.expectation(description: "NextToGo")
        var error: Error?
        
        try CombineNetworkManager.shared.fetchData(urlSession: .shared, .NextToGo(method: "nextraces", count: 10), type: NextToGoResponse.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { response in
                let raceSummaries = response.data.raceSummaries.map({ (nextToGoID, raceSummary) in
                    raceSummary
                })
                XCTAssertLessThan(raceSummaries.count, 11, "there should be less than 11 races")
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
    }
}

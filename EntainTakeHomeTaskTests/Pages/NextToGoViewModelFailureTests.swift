//
//  NextToGoViewModelFailureTests.swift
//  EntainTakeHomeTaskTests
//
//  Created by nana Zhang on 2024/3/15.
//

import XCTest
@testable import EntainTakeHomeTask

final class NextToGoViewModelFailureTests: XCTestCase {

    private var networkMock: AnyNetworkManager!
    private var vm: NextToGoViewModel!
    
    override func setUp() {
        networkMock = NetworkNextToGoFailureMock()
        vm = NextToGoViewModel(networkManager: networkMock)
    }

    override func tearDown() {
        networkMock = nil
        vm = nil
    }

    func test_with_failure_races_is_set() {
        (networkMock as! NetworkNextToGoFailureMock).customError = .badRequest
        
        XCTAssertFalse(vm.isLoading, "The view model shouldn't be loading any data")
        defer {
            XCTAssertFalse(vm.isLoading, "The view model shouldn't be loading any data")
        }
        vm.fetchNextToGo()
        
        let exp = XCTestExpectation(description: "Test after 0.1 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(vm.hasError, "The view model should have an error")
            XCTAssertEqual(vm.latestError, .badRequest, "the error should be badRequest")
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
}

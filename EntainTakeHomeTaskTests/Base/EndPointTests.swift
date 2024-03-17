//
//  EndPointTests.swift
//  EntainTakeHomeTaskTests
//
//  Created by nana Zhang on 2024/3/15.
//

import XCTest
@testable import EntainTakeHomeTask

final class EndPointTests: XCTestCase {

    func next_to_go_url_is_valid() {
        let nextToGo: Endpoint = .NextToGo(method: "nextraces", count: 10)
        XCTAssertEqual(nextToGo.url?.absoluteString, "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10", "url is invalid")
        XCTAssertEqual(nextToGo.methodType, .GET, "method type should be get")
    }
}

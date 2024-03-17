//
//  JSONMapperTests.swift
//  EntainTakeHomeTaskTests
//
//  Created by nana Zhang on 2024/3/14.
//

import XCTest
@testable import EntainTakeHomeTask

final class JSONMapperTests: XCTestCase {
    
    func test_with_valid_json_successfully_decodes() {
        
        XCTAssertNoThrow(try JSONMapper.decode(file: "NextToGoData", type: NextToGoResponse.self), "Mapper shouldn't throw an error")
        
        let nextToGoDataResponse = try? JSONMapper.decode(file: "NextToGoData", type: NextToGoResponse.self)
        let nextToGoData = nextToGoDataResponse?.data
        XCTAssertNotNil(nextToGoData, "data shouldn't be nil")
        
        let raceSummaries = nextToGoData?.raceSummaries
        XCTAssertEqual(raceSummaries?.count, 10, "races count should be 10")
        
        // first item
        let race: RaceSummary? = raceSummaries?["181d9c3b-fca3-4ce2-a586-8b9db466f3d5"]
             
        XCTAssertEqual(race?.meetingName, "Redcliffe", "first meeting name should be Redcliffe")
        XCTAssertEqual(race?.raceName, "Elders Property Management Pace", "first race name should be Elders Property Management Pace")
        XCTAssertEqual(race?.raceNumber, 8, "first race id should be 8")
        

    }
    
    func test_with_invalid_file_error_thrown() {
        XCTAssertThrowsError(try JSONMapper.decode(file: "", type: NextToGoResponse.self), "An error should be thrown")
        do {
            _ = try JSONMapper.decode(file: "", type: NextToGoResponse.self)
        } catch {
            guard let mappingError = error as? JSONMapper.MappingError else {
                XCTFail("The error should be a MappingError")
                return
            }
            XCTAssertEqual(mappingError, JSONMapper.MappingError.failedToDecodeContents, "This should be a failed to decode error")
        }
        
        XCTAssertThrowsError(try JSONMapper.decode(file: "aaaa", type: NextToGoResponse.self), "An error should be thrown")
        do {
            _ = try JSONMapper.decode(file: "aaaa", type: NextToGoResponse.self)
        } catch {
            guard let mappingError = error as? JSONMapper.MappingError else {
                XCTFail("The error should be a MappingError")
                return
            }
            XCTAssertEqual(mappingError, JSONMapper.MappingError.failedToDecodeContents, "This should be a failed to decode error")
        }
    }

}

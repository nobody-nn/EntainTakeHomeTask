//
//  CategoryTests.swift
//  EntainTakeHomeTaskTests
//
//  Created by nana Zhang on 2024/3/15.
//

import XCTest
@testable import EntainTakeHomeTask

final class CategoryTests: XCTestCase {

    func race_categories_is_valid() {
        XCTAssertEqual(Category.allCategories.count, 3, "there should be 3 categories")
        
        XCTAssertEqual(Category.Greyhound.displayName, "Greyhound", "Greyhound's displayName should be Greyhound")
        XCTAssertEqual(Category.Harness.displayName, "Harness", "Harness's displayName should be Harness")
        XCTAssertEqual(Category.Horse.displayName, "Horse", "Horse's displayName should be Horse")
        
        
        XCTAssertEqual(Category.Greyhound.rawValue, "9daef0d7-bf3c-4f50-921d-8e818c60fe61", "Greyhound's rawValue is invalid")
        XCTAssertEqual(Category.Harness.rawValue, "Harness", "161d9be2-e909-4326-8c2c-35ed71fb460b")
        XCTAssertEqual(Category.Horse.rawValue, "Horse", "4a2788f8-e825-4d36-9894-efd4baf1cfae")
    }
}

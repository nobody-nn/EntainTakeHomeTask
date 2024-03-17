//
//  FilterTests.swift
//  EntainTakeHomeTaskTests
//
//  Created by nana Zhang on 2024/3/16.
//

import XCTest
@testable import EntainTakeHomeTask

final class FilterTests: XCTestCase {
    private var vm: FilterViewModel!
    override func setUp() {
        vm = FilterViewModel(allFilterFields: Category.allCategories)
    }
    
    override func tearDown() {
        vm = nil
    }
    
    func test_filter_initial_data_is_valid() {
        XCTAssertEqual(vm.allFilterFields.count, 3, "initial count of allFilterFields should be 3")
        XCTAssertNil(vm.selectedFilterFields, "initial count of selectedFilterFields should be 0")
    }
    
    func test_filter_tapped() {
        // select
        vm.categoryTapped(.Greyhound)
        XCTAssertEqual(vm.selectedFilterFields, [.Greyhound], "The selectedFilterFields should be Greyhound")
        
        // Deselect
        vm.categoryTapped(.Greyhound)
        XCTAssertEqual(vm.selectedFilterFields!.count, 0, "The count of selectedFilterFields should be 0")
        
        // Select two category
        vm.categoryTapped(.Greyhound)
        vm.categoryTapped(.Harness)
        XCTAssertEqual(vm.selectedFilterFields, [.Greyhound, .Harness], "SelectedFilterFields should be Greyhound and Harness")
        
        // Reset
        vm.resetAll()
        XCTAssertNil(vm.selectedFilterFields, "SelectedFilterFields should be nil")
        
        // Select + deselect
        vm.categoryTapped(.Horse)
        vm.categoryTapped(.Horse)
        XCTAssertEqual(vm.selectedFilterFields!.count, 0, "The count of selectedFilterFields should be 0")
        
        vm.resetAll()
        XCTAssertEqual(vm.selectedFilterFields!.count, 0, "The count of selectedFilterFields should be 0")
    }
}

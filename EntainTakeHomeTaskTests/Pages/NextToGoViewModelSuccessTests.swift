//
//  NextToGoViewModelSuccessTests.swift
//  EntainTakeHomeTaskTests
//
//  Created by nana Zhang on 2024/3/15.
//

import XCTest
@testable import EntainTakeHomeTask

final class NextToGoViewModelSuccessTests: XCTestCase {
    private var networkMock: AnyNetworkManager!
    private var vm: NextToGoViewModel!
    
    override func setUp() {
        networkMock = NetworkNextToGoSuccessMock()
        vm = NextToGoViewModel(networkManager: networkMock)
    }
    
    override func tearDown() {
        networkMock = nil
        vm = nil
    }
    
    func test_initial_data_is_valid() {
        XCTAssertEqual(vm.raceSummaries.count, 0, "initial count of race should be 0")
        XCTAssertEqual(vm.displayingRacesCount, 0, "initial displayingRacesCount should be 0")
        XCTAssertFalse(vm.isLoading, "initial isLoading should be false")
        XCTAssertNil(vm.latestError, "initial latestError should be nil")
        XCTAssertFalse(vm.hasError, "initial hasError should be false")
        XCTAssertNil(vm.selectedCategoryIDs, "initial selectedCategoryIDs should be nil")
        XCTAssertEqual(vm.filteredRaceSummaries.count, 0, "initial count of filtered race should be 0")
        
    }
    
    func test_refresh_timer_should_have_data() {
        vm.autoRefreshInterval = 3
        vm.startRefreshTimer()
        
        XCTAssertNotNil(vm.exposeTimer())
        
        // should have data after 3.1 seconds
        verify_race_data_valid_with_timeout(timeout: 3.1)
    }
    
    func test_refresh_timer_should_not_work_with_filter_shows() {
        vm.autoRefreshInterval = 3
        vm.shouldShowFilter = true
        vm.startRefreshTimer()
        XCTAssertNotNil(vm.exposeTimer())
        
        // should NOT have data after 3.1 seconds
        let requestExp = XCTestExpectation(description: "Test after 3 seconds")
        let requestResult = XCTWaiter.wait(for: [requestExp], timeout: 3.1)
        if requestResult == XCTWaiter.Result.timedOut {
            XCTAssertFalse(vm.raceSummaries.count > 0, "should have data now")
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_with_successful_response_races_is_set() {
        
        XCTAssertFalse(vm.isLoading, "The view model shouldn't be loading any data")
        defer {
            XCTAssertFalse(vm.isLoading, "The view model shouldn't be loading any data")
        }
        vm.fetchNextToGo()
        verify_race_data_valid_with_timeout(timeout: 0.1)
    }
    
    func test_reset_error_after_manual_refresh() {
        vm.hasError = true
        vm.setLatestError(err: .badRequest)
        
        vm.manualRefresh()
        
        XCTAssertNil(vm.latestError, "latestError should be nil after manual refresh")
        XCTAssertFalse(vm.hasError, "hasError should be false after manual refresh")
    }
    
    func test_handle_error_set_an_error() {
        XCTAssertNil(vm.latestError, "initial latestError should be nil")
        XCTAssertFalse(vm.hasError, "initial hasError should be false")
        vm.exposeHandleError(err: .forbidden)
        
        XCTAssertNotNil(vm.latestError, "latestError should not be nil")
        XCTAssertTrue(vm.hasError, "hasError should be true")
    }
    
    func verify_race_data_valid_with_timeout(timeout: TimeInterval) {
        let exp = XCTestExpectation(description: "Test after \(timeout) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: timeout)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(vm.raceSummaries.count, 10, "There should be 10 races")
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_filter_race_data() {
        
        let (mockResponse, latestRace, secondsRace, minutesRace, hoursRace, theFifthRace) = mockNextToGoResponse()
        
        // remaining time format is valid
        XCTAssertEqual(latestRace.advertisedStart.displayStart, "-30s", "remaining time should be -30s")
        XCTAssertEqual(secondsRace.advertisedStart.displayStart, "59s", "remaining time should be 59s")
        XCTAssertTrue(minutesRace.advertisedStart.displayStart.contains("m"), "remaining time should be xxm xxs")
        XCTAssertTrue(hoursRace.advertisedStart.displayStart.contains(":"), "remaining time should be HH:mm aa")
 
        vm.setRaceSummaries(races: mockResponse.data.raceSummaries.map({ (key: String, value: RaceSummary) in
            value
        }))
        
        let filterViewModel: FilterViewModel = FilterViewModel(allFilterFields: Category.allCategories)
        vm.filterViewModel = filterViewModel
        
        // without filtering
        XCTAssertEqual(vm.filteredRaceSummaries.count, 5, "should have 5 filtered races")
        XCTAssertEqual(vm.filteredRaceSummaries[0].raceID, latestRace.raceID, "the first race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[1].raceID, secondsRace.raceID, "the second race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[2].raceID, minutesRace.raceID, "the third race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[3].raceID, hoursRace.raceID, "the forth race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[4].raceID, theFifthRace.raceID, "the fifth race is wrong")
        
        // filter by Greyhound
        vm.filterViewModel.categoryTapped(Category.Greyhound)
        XCTAssertEqual(vm.selectedCategoryIDs?.count, 1, "Should contains 1 categories")
        let _ = vm.filteredRaceSummaries.map { raceSummary in
            XCTAssertEqual(raceSummary.categoryName, "Greyhound", "should only have Greyhound category")
            XCTAssertEqual(raceSummary.categoryID, "9daef0d7-bf3c-4f50-921d-8e818c60fe61", "categoryID is wrong")
        }
        
        // filter by Greyhound + Harness
        vm.filterViewModel.categoryTapped(Category.Harness)
        XCTAssertEqual(vm.selectedCategoryIDs?.count, 2, "Should contains 2 categories")
        let _ = vm.filteredRaceSummaries.map { raceSummary in
            XCTAssertNotEqual(raceSummary.categoryName, "Horse", "should NOT have Horse category")
            XCTAssertNotEqual(raceSummary.categoryID, "4a2788f8-e825-4d36-9894-efd4baf1cfae", "categoryID is wrong")
        }
        
        // Now, all selected
        vm.filterViewModel.categoryTapped(Category.Horse)
        XCTAssertEqual(vm.selectedCategoryIDs?.count, 3, "Should contains all 3 categories")
        XCTAssertEqual(vm.filteredRaceSummaries.count, 5, "should have 5 filtered races")
        XCTAssertEqual(vm.filteredRaceSummaries[0].raceID, latestRace.raceID, "the first race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[1].raceID, secondsRace.raceID, "the second race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[2].raceID, minutesRace.raceID, "the third race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[3].raceID, hoursRace.raceID, "the forth race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[4].raceID, theFifthRace.raceID, "the fifth race is wrong")
        
        // Horse Deselected
        vm.filterViewModel.categoryTapped(Category.Horse)
        XCTAssertEqual(vm.selectedCategoryIDs?.count, 2, "Should contains 2 categories")
        XCTAssertFalse(vm.filterViewModel.categoryIsSelected(Category.Horse), "Horse should not been selected")
        
        // reset
        vm.filterViewModel.resetAll()
        XCTAssertNil(vm.selectedCategoryIDs, "selected category should be empty")
        XCTAssertEqual(vm.filteredRaceSummaries.count, 5, "should have 5 filtered races")
        XCTAssertEqual(vm.filteredRaceSummaries[0].raceID, latestRace.raceID, "the first race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[1].raceID, secondsRace.raceID, "the second race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[2].raceID, minutesRace.raceID, "the third race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[3].raceID, hoursRace.raceID, "the forth race is wrong")
        XCTAssertEqual(vm.filteredRaceSummaries[4].raceID, theFifthRace.raceID, "the fifth race is wrong")
        XCTAssertFalse(vm.shouldShowFilter, "filter should be dismissed")
    }
}

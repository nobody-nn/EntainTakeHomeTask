//
//  NextToGoViewModel.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import Foundation
import Combine
import SwiftUI

#if DEBUG
// This is only for the test
extension NextToGoViewModel {
    func setLatestError(err: NetworkRequestError) {
        latestError = err
    }
    func setRaceSummaries(races:  [RaceSummary]) {
        raceSummaries = races
    }
    func setRequestFailuresCount(count: Int) {
        requestFailuresCount = count
    }
    func exposeHandleError(err: NetworkRequestError) {
        handleError(err: err)
    }
    func exposeTimer() -> AnyCancellable?{
        return requestTimer
    }
}
#endif

final class NextToGoViewModel: ObservableObject{
#if DEBUG
    var isPreview: Bool = false
#endif
    /// Used to store all races requested from the server
    @Published private(set) var raceSummaries: [RaceSummary] = []
    var displayingRacesCount = 0
    /// filter model
    var filterViewModel: FilterViewModel = FilterViewModel(allFilterFields: Category.allCategories)
    @Published var shouldShowFilter = false
    
    /// use this to show the loading ui
    @Published var isLoading = false
    /// the latest error for the request
    @Published private(set) var latestError: NetworkRequestError?
    @Published var hasError: Bool = false
    
    /// selected by user, use this to filter the race list
    var selectedCategoryIDs: [String]? {
        guard let selectedCategories = filterViewModel.selectedFilterFields, selectedCategories.count > 0 else {
            return nil
        }
        return selectedCategories.map { category in
            category.rawValue
        }
    }
    
    /// server request
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: AnyNetworkManager
    /// current failures count under auto refresh
    private var requestFailuresCount = 0
    /// max failures count for auto refresh
    static let maxFailuresCount = 3
    
    /// request server per ? second
    var autoRefreshInterval: TimeInterval = 30
    private var requestTimer: AnyCancellable?
    
    
    init(networkManager: AnyNetworkManager = CombineNetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// all races to display with filter and order and top 5
    var filteredRaceSummaries: [RaceSummary] {
        guard raceSummaries.count > 0 else {
            return []
        }
        
        let filteredResult = raceSummaries.filter { raceSummary in
            /// 1. only show selected categories & hasn't gone past 60 seconds
            let maxExpirationSeconds = -60
            if let selectedCategoryIDs {
                return selectedCategoryIDs.firstIndex(of: raceSummary.categoryID) != nil && raceSummary.advertisedStart.remainingSeconds >= maxExpirationSeconds
            } else {
                return raceSummary.advertisedStart.remainingSeconds >= maxExpirationSeconds
            }
        }
        
        /// 2. order
        let sortedResult = filteredResult.sorted {
            // When the time is equal, to prevent shake when the page is refreshed, add another condition
            if $0.advertisedStart.seconds == $1.advertisedStart.seconds {
                return $0.raceName < $1.raceName
            } else {
                return $0.advertisedStart.seconds < $1.advertisedStart.seconds
            }
        }
        
        /// 3. first 5
        let displayingResult = Array(sortedResult.prefix(5))
        
        displayingRacesCount = displayingResult.count
        
        return displayingResult
    }
    
    /// start request refresh timer
    func startRefreshTimer() {
        
        /// If the request fails too many times, the refresh won't work
        if requestTimer == nil {
            print("create a new requestTimer")
            requestTimer = Timer.publish(every: autoRefreshInterval, on: .main, in: .common).autoconnect().sink { _ in
                // If the request fails too many times, the refresh should be stopped
                if !self.shouldShowFilter
                    && self.requestFailuresCount < Self.maxFailuresCount {
                    self.fetchNextToGo()
                }
            }
        }
    }
    
    func cancelRefreshTimer() {
        requestTimer?.cancel()
    }
    
    /// refresh triggered by user
    func manualRefresh() {
        // should reset the error related properties
        resetError()
        fetchNextToGo()
    }
    
    /// get the whole list
    func fetchNextToGo() {
#if DEBUG
        if isPreview {
            print("Running in Preview Mode")
            do {
                let nextToGoResponse = try JSONMapper.decode(file: "NextToGoData", type: NextToGoResponse.self)
                raceSummaries = nextToGoResponse.data.raceSummaries.map({ (nextToGoID, raceSummary) in
                    raceSummary
                })
            } catch {
                print("error: \(error)")
            }
        } else {
            fetchNextToGoFromServer()
        }
#else
        fetchNextToGoFromServer()
#endif
    }
    
    /// get the whole list from the real server
    private func fetchNextToGoFromServer() {
        isLoading = true
        do {
            try networkManager.fetchData(urlSession: .shared,
                                         .NextToGo(method: "nextraces", count: 10),
                                         type: NextToGoResponse.self)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                guard let self else {
                    return
                }
                
                self.isLoading = false
                switch completion {
                case .finished:
                    print("fetch finished")
                case .failure(let err):
                    print("fetch failed:\(err)")
                    
                    self.handleError(err: err)
                }
            } receiveValue: {[weak self] nextToGoResponse in
                guard let self else {
                    return
                }
                
                defer {
                    self.resetError()
                }
                self.raceSummaries = nextToGoResponse.data.raceSummaries.map({ (nextToGoID, raceSummary) in
                    raceSummary
                })
            }
            .store(in: &cancellables)
        } catch {
            handleError(err: error as? NetworkRequestError)
        }
    }
    
    private func resetError() {
        handleError(err: nil)
    }
    
    private func handleError(err: NetworkRequestError?) {
        if err != nil {
            requestFailuresCount += 1
            latestError = err
            hasError = true
        } else {
            requestFailuresCount = 0
            latestError = nil
            hasError = false
        }
    }
}

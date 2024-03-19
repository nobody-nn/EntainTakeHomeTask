//
//  NextToGoView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import SwiftUI
import Combine

struct NextToGoView: View {
    @StateObject private var nextToGoViewModel: NextToGoViewModel
    @State private var hasAppeared = false
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.isPreview) var isPreview
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State var showNetworkAlert = false
    
    init() {
#if DEBUG
        if UITestingHelper.isUITesting {
            if UITestingHelper.isNextToGoNetworkSuccessful {
                // mock success
                let networkMock: NetworkNextToGoSuccessMock = NetworkNextToGoSuccessMock()
                // use mock data for network request
                let (mockResponse, _, _, _, _, _) = mockNextToGoResponse()
                networkMock.nextToGoResult = Result<NextToGoResponse, NetworkRequestError>
                    .Publisher(.success(mockResponse))
                    .eraseToAnyPublisher()
                _nextToGoViewModel = StateObject(wrappedValue: NextToGoViewModel(networkManager: networkMock))
            } else {
                // mock fail
                let networkMock: NetworkNextToGoFailureMock = NetworkNextToGoFailureMock()
                networkMock.customError = UITestingHelper.nextToGoNetworkError
                _nextToGoViewModel = StateObject(wrappedValue: NextToGoViewModel(networkManager: networkMock))
            }
        } else {
            _nextToGoViewModel = StateObject(wrappedValue: NextToGoViewModel(networkManager: CombineNetworkManager.shared))
        }
#else
        _nextToGoViewModel = StateObject(wrappedValue: NextToGoViewModel(networkManager: CombineNetworkManager.shared))
#endif
        
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundView
                if nextToGoViewModel.isLoading && nextToGoViewModel.raceSummaries.count == 0 {
                    ProgressView()
                } else {
                    /// the whole races list
                    raceList
                }
            }
            .navigationTitle("Next To Go")
            .toolbar {
                ToolbarItem(placement: .primaryAction) { filterItem }
                ToolbarItem(placement: .topBarLeading) { refreshItem }
            }
            .sheet(isPresented: $nextToGoViewModel.shouldShowFilter, content: {
                FilterView(filterViewModel: nextToGoViewModel.filterViewModel,
                           shouldShowFilter: $nextToGoViewModel.shouldShowFilter)
            })
            .onAppear() {
                print("onAppear")
                if !hasAppeared {
                    // the first request
                    nextToGoViewModel.fetchNextToGo()
                    hasAppeared = true
                }
                nextToGoViewModel.startRefreshTimer()
            }
            .onDisappear() {
                print("onDisappear")
                nextToGoViewModel.cancelRefreshTimer()
            }
            .onChange(of: scenePhase, perform: { newPhase in
                switch newPhase {
                case .background, .inactive:
                    nextToGoViewModel.cancelRefreshTimer()
                case .active:
                    nextToGoViewModel.startRefreshTimer()
                @unknown default:
                    print("Unknown state")
                }
            })
            .onChange(of: networkMonitor.hasNetworkConnection, perform: { newValue in
                showNetworkAlert = !newValue
            })
            .alert("No network",
                   isPresented: $showNetworkAlert,
                   actions: {
                Text("OK")
            })
        }
    }
}

private extension NextToGoView {
    /// the whole races list with: remaining time + meeting name + race number + race name
    /// when the list is empty, show the description and retry button
    var raceList: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { _ in
            List {
                ForEach(nextToGoViewModel.filteredRaceSummaries, id: \.raceID) { raceSummary in
                    NavigationLink {
                        Text(raceSummary.raceName)
                    } label: {
                        HStack {
                            // remaining time
                            RemainingTimeView(title: raceSummary.advertisedStart.displayStart, isExpired: raceSummary.advertisedStart.remainingSeconds < 0)
                            // meeting name + race number + race name
                            RaceItemDetailView(raceSummary: raceSummary)
                        }
                    }
                }
            }
            .overlay {
                // when the list is empty, show the description and retry button
                if nextToGoViewModel.displayingRacesCount == 0 {
                    let description = nextToGoViewModel.hasError ? nextToGoViewModel.latestError?.errorDescription : "No Next To Go Race!"
                    EmptyView(description: description, retryAction: {
                        nextToGoViewModel.manualRefresh()
                    })
                }
            }
            
        }
    }
}

private extension NextToGoView {
    /// manual refresh button at top leading of toolbar
    var refreshItem: some View {
        Button {
            nextToGoViewModel.manualRefresh()
        } label: {
            Symbols.refresh
        }
        .disabled(nextToGoViewModel.isLoading)
        .accessibilityLabel("refresh race list")
        .accessibilityIdentifier("refresh_button")
    }
}

private extension NextToGoView {
    /// filter button at top trailing of toolbar
    var filterItem: some View {
        Button {
            nextToGoViewModel.shouldShowFilter.toggle()
        } label: {
            Symbols.filter
        }
        .disabled(nextToGoViewModel.isLoading || nextToGoViewModel.raceSummaries.count == 0)
        .accessibilityLabel("filter by category")
        .accessibilityIdentifier("filter_button")
    }
}

private extension NextToGoView {
    var backgroundView: some View {
        Theme.detailBackground.ignoresSafeArea(.all)
    }
}

#Preview {
    NextToGoView().environment(\.isPreview, true)
}


//
//  FilterView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

import SwiftUI
import WaterfallGrid

struct FilterView: View {
    @StateObject var filterViewModel: FilterViewModel
    @Binding var shouldShowFilter: Bool
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .trailing) {
                GeometryReader { geometry in
                    VStack {
                        // categories list
                        categoriesView
                        
                        // two button at the bottom
                        submitActionsView
                            .frame(width: geometry.size.width > 32 ? geometry.size.width - 32 : .infinity)
                            .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("Filter by Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem {
                    closeButton
                }
            })
        }
    }
}

private extension FilterView {
    var categoriesView: some View {
        ScrollView {
            WaterfallGrid(filterViewModel.allFilterFields, id: \.self) { category in
                Button(action: {
                    // update selected list
                    filterViewModel.categoryTapped(category)
                }, label: {
                    FilterButton(title: "\(category.displayName)", isSelected: filterViewModel.categoryIsSelected(category))
                })
                .accessibilityIdentifier("category_\(category.displayName)")
                .accessibilityLabel(category.displayName)
            }
            .padding(.top, 16)
        }
    }
}

private extension FilterView {
    var closeButton: some View {
        Button(action: {
            shouldShowFilter = false
        }, label: {
            Symbols.closeCircle
                .foregroundStyle(Color.accentColor)
        })
        .accessibilityLabel("Close")
    }
}

private extension FilterView {
    /// reset button + submitButton
    var submitActionsView: some View {
        HStack {
            Button(action: {
                // reset
                shouldShowFilter = false
                filterViewModel.resetAll()
            }, label: {
                GeneralButton(title: "Reset")
            })
            .accessibilityLabel("Reset")
            
            Button(action: {
                // submit
                shouldShowFilter = false
            }, label: {
                GeneralButton(title: "Submit", isPrimary: true)
            })
            .accessibilityLabel("Submit")
        }
    }
}

private extension FilterView {
    var backgroundView: some View {
        Theme.contentBackground.ignoresSafeArea(.all)
    }
}

#Preview {
    FilterView(filterViewModel:FilterViewModel(allFilterFields: Category.allCategories),  shouldShowFilter: .constant(true))
}

//
//  FilterViewModel.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

import Foundation

class FilterViewModel: ObservableObject {
    /// all categories
    var allFilterFields:[Category]
    /// User selection results
    @Published private(set) var selectedFilterFields:[Category]?
    
    init(allFilterFields: [Category]) {
        self.allFilterFields = allFilterFields
    }
    
    /// select or deselected a category
    /// - parameter category: the category user just tapped
    func categoryTapped(_ category: Category) {
        if selectedFilterFields == nil {
            selectedFilterFields = [category]
        } else {
            if let index = selectedFilterFields?.firstIndex(of: category) {
                selectedFilterFields?.remove(at: index)
            } else {
                selectedFilterFields?.append(category)
            }
        }
    }
    
    /// If a category is selected by user
    /// - Parameter category: which category you are dealing with
    /// - Returns: true: the category is selected
    func categoryIsSelected(_ category: Category) -> Bool {
        (selectedFilterFields?.firstIndex(of: category)) != nil
    }
    
    /// clear filters
    func resetAll() {
        if selectedFilterFields?.count ?? 0 > 0 {
            selectedFilterFields = nil
        }
    }
}

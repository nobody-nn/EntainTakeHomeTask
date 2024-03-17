//
//  Category.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import Foundation

/// category_id -> actual meaning
enum Category: String {
    
    static var allCategories: [Category]
    {
        return [
            .Greyhound,
            .Harness,
            .Horse
        ]
    }
    
    case Greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case Harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case Horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    
    var displayName: String {
        switch self {
        case .Greyhound:
            return "Greyhound"
        case .Harness:
            return "Harness"
        case .Horse:
            return "Horse"
        }
    }
}

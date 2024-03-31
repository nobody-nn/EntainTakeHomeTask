//
//  Models.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import Foundation

struct NextToGoResponse: Codable {
    let status: Int
    let data: NextToGoData
    let message: String
}

struct NextToGoData: Codable {
    let nextToGoIDS: [String]
    let raceSummaries: [String: RaceSummary]

    enum CodingKeys: String, CodingKey {
        case nextToGoIDS = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}

#if DEBUG
extension RaceSummary {
    // This is only for test
    mutating func changeAdvertisedStart(newValue: AdvertisedStart) {
        advertisedStart = newValue
    }
}
#endif

struct RaceSummary: Codable, Hashable {
    static func == (lhs: RaceSummary, rhs: RaceSummary) -> Bool {
        lhs.raceID == rhs.raceID
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(raceID)
    }
    
    let raceID, raceName: String
    let raceNumber: Int
    let meetingID, meetingName, categoryID: String
    private(set) var advertisedStart: AdvertisedStart
    let venueID, venueName, venueState: String
    let venueCountry: String

    enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingID = "meeting_id"
        case meetingName = "meeting_name"
        case categoryID = "category_id"
        case advertisedStart = "advertised_start"
        case venueID = "venue_id"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }
    
    var categoryName: String {
        if let category = Category.allCategories.first(where: { category in
            category.rawValue == categoryID
        }) {
            return category.displayName
        } else {
            print("unknown category")
            return ""
        }
    }
}

struct AdvertisedStart: Codable {
    let seconds: Int
    
    var remainingSeconds: Int {
        let startDate = Date(timeIntervalSince1970: TimeInterval(seconds))
        let interval = startDate.timeIntervalSinceNow
        return Int(interval)
    }
    
    /// display string for remaining time with difference type
    /// 1. remaining time < 60s: 36s
    /// 2. remaining time is in 60s...3600s:  27m 56s
    /// 3. remaining time > 3600s: 22:02 pm
    var displayStart: String {
        let startDate = Date(timeIntervalSince1970: TimeInterval(seconds))
        let interval = Int(startDate.timeIntervalSinceNow)
        
        if interval > 3600 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm aa" // formated time
            return dateFormatter.string(from: startDate)
        } else if interval > 60 {
            let minutes: Int = interval / 60
            let remainingSeconds: Int = Int(interval) % 60
            return "\(minutes)m \(remainingSeconds)s"
        } else {
            return "\(interval)s"
        }
    }
}


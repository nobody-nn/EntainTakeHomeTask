//
//  MockData.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

#if DEBUG
import Foundation

/// use the data of json file to generate specific top 5 races
func mockNextToGoResponse() -> (NextToGoResponse, RaceSummary,RaceSummary ,RaceSummary, RaceSummary, RaceSummary) {
    let mockNextToGoResponse = try! JSONMapper.decode(file: "NextToGoData", type: NextToGoResponse.self)
    let timeInterval = Date().timeIntervalSince1970
    /*
     1. remaining time < 60s: 36s
     2. remaining time is in 60s...3600s:  27m 56s
     3. remaining time > 3600s: 22:02 pm
     */
    var expiredRace: RaceSummary?
    var latestRace: RaceSummary?
    var secondsRace: RaceSummary?
    var minutesRace: RaceSummary?
    var hoursRace: RaceSummary?
    var theFifthRace: RaceSummary?
    
    let newArray = mockNextToGoResponse.data.raceSummaries.map({ (nextToGoID, raceSummary) in
        var race = raceSummary
        var advertisedStart: AdvertisedStart?
        
        if expiredRace == nil && nextToGoID == mockNextToGoResponse.data.nextToGoIDS[0] {
            advertisedStart = AdvertisedStart(seconds: Int(timeInterval) - 61)
            race.changeAdvertisedStart(newValue: advertisedStart!)
            expiredRace = race
        } else if latestRace == nil && nextToGoID == mockNextToGoResponse.data.nextToGoIDS[1] {
            advertisedStart = AdvertisedStart(seconds: Int(timeInterval) - 30)
            race.changeAdvertisedStart(newValue: advertisedStart!)
            latestRace = race
        } else if secondsRace == nil && nextToGoID == mockNextToGoResponse.data.nextToGoIDS[2] {
            advertisedStart = AdvertisedStart(seconds: Int(timeInterval) + 60)
            race.changeAdvertisedStart(newValue: advertisedStart!)
            secondsRace = race
        } else if minutesRace == nil && nextToGoID == mockNextToGoResponse.data.nextToGoIDS[3] {
           advertisedStart = AdvertisedStart(seconds: Int(timeInterval) + 3600)
            race.changeAdvertisedStart(newValue: advertisedStart!)
            minutesRace = race
       } else if hoursRace == nil && nextToGoID == mockNextToGoResponse.data.nextToGoIDS[4] {
           advertisedStart = AdvertisedStart(seconds: Int(timeInterval) + 4000)
           race.changeAdvertisedStart(newValue: advertisedStart!)
           hoursRace = race
       } else if theFifthRace == nil && nextToGoID == mockNextToGoResponse.data.nextToGoIDS[5] {
           advertisedStart = AdvertisedStart(seconds: Int(timeInterval) + 5000)
           race.changeAdvertisedStart(newValue: advertisedStart!)
           theFifthRace = race
       } else {
           advertisedStart = AdvertisedStart(seconds: Int(timeInterval) + Int.random(in: 5000...50000))
           race.changeAdvertisedStart(newValue: advertisedStart!)
       }
        
        return (nextToGoID, race)
    })
    
    let data:[String: RaceSummary] = Dictionary(uniqueKeysWithValues: newArray)
    let nextToGoResponse = NextToGoResponse(status: mockNextToGoResponse.status,
                                            data: NextToGoData(nextToGoIDS: mockNextToGoResponse.data.nextToGoIDS,
                                                               raceSummaries: data),
                                            message: mockNextToGoResponse.message)
    return (nextToGoResponse, latestRace!, secondsRace!, minutesRace!, hoursRace!, theFifthRace!)
}

#endif

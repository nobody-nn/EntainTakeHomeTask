//
//  RaceItemDetailView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

import SwiftUI

/// A detail view contains: meeting name, category name, race number, race name
struct RaceItemDetailView: View {
    var raceSummary: RaceSummary
    var body: some View {
        VStack(alignment: .leading) {
            // meeting name
            Text(raceSummary.meetingName)
                .font(.title2)
                .foregroundStyle(Theme.headerText)
                .frame(maxWidth:.infinity, alignment: .leading)
                .overlay(alignment: .trailing) {
                    // mostly for debug
                    Text(raceSummary.categoryName)
                        .font(.footnote)
                        .foregroundStyle(Theme.footerText)
                }
                .accessibilityLabel(raceSummary.meetingName)
            
            Divider()
                .padding(0)
            
            HStack(alignment: .center) {
                // race number
                Text(String(raceSummary.raceNumber))
                    .font(
                        .system(.headline)
                        .bold()
                    )
                    .padding(.horizontal, 6)
                    .background(Theme.number, in: Capsule())
                    .accessibilityLabel("\(raceSummary.raceNumber)")
                
                // race name
                Text(raceSummary.raceName)
                    .lineLimit(2)
                    .font(.headline.weight(.regular))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .accessibilityLabel(raceSummary.raceName)
            }
            .foregroundStyle(Theme.bodyText)
        }
        .padding(.all,8)
        .background(Theme.contentBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8,style: .continuous))
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    let nextToGoResponse = try! JSONMapper.decode(file: "NextToGoData", type: NextToGoResponse.self)
    let raceSummaries = nextToGoResponse.data.raceSummaries.map({ (nextToGoID, raceSummary) in
        raceSummary
    })
    return RaceItemDetailView(raceSummary: raceSummaries.first!)
        .frame(width: 260)
}

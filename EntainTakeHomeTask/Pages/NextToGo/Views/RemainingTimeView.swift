//
//  RemainingTimeView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

import SwiftUI

/// Count down time view with a clock icon
struct RemainingTimeView: View {
    var title: String = "0s"
    var isExpired: Bool = false
    
    var body: some View {
        VStack {
            Symbols.clock
                .foregroundStyle(Theme.headerText)
            Text(title)
                .font(.footnote)
                .foregroundStyle(isExpired ? Theme.expiredAlert : Theme.alert)
                .padding(.top, 2)
        }
        .frame(width: 60)
        .accessibilityLabel("Remaining time is \(title)")
    }
}

#Preview {
    RemainingTimeView()
}

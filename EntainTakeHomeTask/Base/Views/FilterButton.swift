//
//  FilterButton.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

import SwiftUI

/// Capsule button has selected style
struct FilterButton: View {
    var title: LocalizedStringKey
    var isSelected: Bool
    var body: some View {
        Text(title)
            .font(.title3)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(
                isSelected ? Theme.lightAccentColor : Theme.lightBackground
            )
            .clipShape(Capsule())
            .foregroundColor(Theme.headerText)
            .cornerRadius(10)
    }
}

#Preview {
    FilterButton(title: "title test", isSelected: true)
}

//
//  GeneralButton.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

import SwiftUI

/// Capsule button with accent color
struct GeneralButton: View {
    var title: LocalizedStringKey
    var isPrimary: Bool = false
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(isPrimary ? .bold : .regular)
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(
                Capsule()
                    .fill(Color.accentColor)
            )
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

#Preview {
    GeneralButton(title: "title")
}

//
//  EmptyView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/14.
//

import SwiftUI
/// A view show empty info with retry button
struct EmptyView: View {
    /// content display below the image
    var description: String?
    /// If this parameter is passed in, a retry button will be displayed
    var retryAction: (() -> Void)?
    var body: some View {
        VStack {
            Symbols.empty
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .foregroundStyle(Color.accentColor.opacity(0.5))
            
            Text(description ?? "Oh no, nothing is here!")
                .padding(.top, 30)
                .font(.title2)
                .foregroundStyle(Theme.bodyText)
                .accessibilityLabel(description ?? "Oh no, nothing is here!")
                .accessibilityIdentifier("empty_description")
            
            if retryAction != nil {
                Button(action: {
                    retryAction!()
                }, label: {
                    GeneralButton(title: "Retry")
                        .frame(width: 120)
                })
                .padding(.top, 16)
                .accessibilityLabel("Retry")
                .accessibilityIdentifier("retry_button")
            }
        }
    }
}

#Preview {
    EmptyView()
}

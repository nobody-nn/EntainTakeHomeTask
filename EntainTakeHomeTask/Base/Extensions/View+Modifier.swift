//
//  View+Modifier.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/31.
//

import SwiftUI

public extension View {
  /// Modify a view with a `ViewBuilder` closure.
  ///
  /// This represents a streamlining of the
  /// [`modifier`](https://developer.apple.com/documentation/swiftui/view/modifier(_:))
  /// \+ [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier)
  /// pattern.
  /// - Note: Useful only when you don't need to reuse the closure.
  /// If you do, turn the closure into an extension! ♻️
  func modifier<ModifiedContent: View>(
    @ViewBuilder body: (_ content: Self) -> ModifiedContent
  ) -> ModifiedContent {
    body(self)
  }
}

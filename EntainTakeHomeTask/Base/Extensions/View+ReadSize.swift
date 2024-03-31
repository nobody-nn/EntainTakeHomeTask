//
//  View+ReadSize.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/31.
//

import SwiftUI

/// https://fivestars.blog/articles/swiftui-share-layout-information/

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

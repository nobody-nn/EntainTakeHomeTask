//
//  IsPreviewEnvironmentModel.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/15.
//

import SwiftUI

private struct IsPreviewKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isPreview: Bool {
        get { self[IsPreviewKey.self] }
        set { self[IsPreviewKey.self] = newValue }
    }
}

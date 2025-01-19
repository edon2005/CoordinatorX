//
//  StatusBarModifiers.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 09/01/2025.
//

import SwiftUI


struct NavStatusBarHiddenKey: PreferenceKey {
    static let defaultValue: Bool? = nil

    static func reduce(value: inout Bool?, nextValue: () -> Bool?) {
        guard let result = nextValue() else { return }
        value = result
    }
}

extension View {
    public func navStatusBar(isHidden: Bool) -> some View {
        preference(key: NavStatusBarHiddenKey.self, value: isHidden)
    }
}

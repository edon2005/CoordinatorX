//
//  StatusBarModifiers.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 09/01/2025.
//

import SwiftUI

struct StatusBar: ViewModifier {

    let isHidden: Bool

    func body(content: Content) -> some View {
        let _ = statusBarHiddenSubject.send(isHidden)
        content
    }
}

extension View {
    public func navStatusBar(isHidden: Bool) -> some View {
        let statusBar = StatusBar(isHidden: isHidden)
        return modifier(statusBar)
    }
}

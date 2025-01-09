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
        content
            .task {
                statusBarHiddenSubject.send(isHidden)
            }
    }
}

extension View {
    public func navStatusBar(isHidden: Bool) -> some View {
        modifier(StatusBar(isHidden: isHidden))
    }
}

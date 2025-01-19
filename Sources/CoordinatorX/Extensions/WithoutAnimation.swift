//
//  WithoutAnimation.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 19/01/2025.
//

import SwiftUI

extension View {
    public func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}

//
//  View + Ext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

extension View {
    @inlinable nonisolated public func overlay<V>(@ViewBuilder content: () -> V) -> some View where V : View {
        content()
    }
}

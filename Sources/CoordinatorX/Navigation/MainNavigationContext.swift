//
//  MainNavigationContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import SwiftUI

public struct MainNavigationContext<CoordinatorType: NavigationCoordinator>: View {
    let coordinator: CoordinatorType
}

public extension MainNavigationContext {
    var body: some View {
        NavigationContext(rootRoute: coordinator.initialRoute, coordinator: coordinator)
    }
}

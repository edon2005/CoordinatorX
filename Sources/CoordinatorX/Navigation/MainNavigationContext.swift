//
//  MainNavigationContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import SwiftUI

public struct MainNavigationContext<CoordinatorType: NavigationCoordinator>: View {
    let coordinator: CoordinatorType

    public init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }
}

public extension MainNavigationContext {
    var body: some View {
        NavigationContext(rootRoute: coordinator.initialRoute, coordinator: coordinator)
    }
}

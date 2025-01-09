//
//  MainRedirectionViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import SwiftUI

public struct MainRedirectionViewContext<CoordinatorType: RedirectionCoordinator>: View {
    let coordinator: CoordinatorType

    public init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }
}

public extension MainRedirectionViewContext {
    var body: some View {
        RedirectionViewContext(rootRoute: coordinator.initialRoute, coordinator: coordinator)
    }
}

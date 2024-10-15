//
//  MainViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

public struct MainViewContext<RouteType: Route, CoordinatorType: Coordinator>: View where CoordinatorType.RouteType == RouteType, CoordinatorType.TransitionType == ViewTransitionType {

    let coordinator: CoordinatorType

    public var body: some View {
        ViewContext(route: coordinator.initialRoute, coordinator: coordinator, isRoot: true)
    }

    public init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }
}

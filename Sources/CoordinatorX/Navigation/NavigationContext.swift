//
//  NavigationContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import SwiftUI

public struct NavigationContext<RouteType: Route,
                                CoordinatorType: NavigationCoordinator>: Context where CoordinatorType.RouteType == RouteType {

    @StateObject
    public var tranisitionContext: NavigationTransitionContext<RouteType, CoordinatorType>

    private let coordinator: CoordinatorType

    public var body: some View {
        NavigationStack(path: $tranisitionContext.path) {
            coordinator.prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
                .navigationDestination(for: RouteType.self) { route in
                    NavigationViewContext(rootRoute: route, coordinator: coordinator, rootTransitionContext: tranisitionContext)
                }
        }
        .fullScreenCover(item: $tranisitionContext.fullScreenRoute) { route in
            NavigationViewContext(rootRoute: route, coordinator: coordinator, rootTransitionContext: tranisitionContext)
        }
        .overlay {
            if let route = tranisitionContext.overlayRoute {
                NavigationViewContext(rootRoute: route, coordinator: coordinator, rootTransitionContext: tranisitionContext)
            }
        }
        .sheet(item: $tranisitionContext.sheetRoute) { route in
            NavigationViewContext(rootRoute: route, coordinator: coordinator, rootTransitionContext: tranisitionContext)
        }
    }

    init(rootRoute: RouteType,
         coordinator: CoordinatorType) {
        self.coordinator = coordinator
        self._tranisitionContext = StateObject(wrappedValue: .init(rootRoute: rootRoute, delegate: coordinator, prevTransitionContext: nil))
    }
}


//
//  NavigationContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import SwiftUI

public struct NavigationContext<RouteType: Route,
                                CoordinatorType: ViewCoordinator>: Context where CoordinatorType.RouteType == RouteType {

    @StateObject
    public var tranisitionContext: ViewTransitionContext<RouteType, CoordinatorType>

    private let coordinator: CoordinatorType

    public var body: some View {
        NavigationStack {
            coordinator.prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
        }
        .navigationDestination(for: RouteType.self) { route in
            coordinator.prepareView(for: route, router: tranisitionContext)
        }
        .fullScreenCover(item: $tranisitionContext.fullScreenRoute) { route in
            
            Self(rootRoute: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
        }
        .overlay {
            if let route = tranisitionContext.overlayRoute {
                Self(rootRoute: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
            }
        }
        .sheet(item: $tranisitionContext.sheetRoute) { route in
            Self(rootRoute: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
        }
    }

    public init(rootRoute: RouteType,
                coordinator: CoordinatorType,
                isRoot: Bool = false,
                prevTransitionContext: ViewTransitionContext<RouteType, CoordinatorType>? = nil) {
        self.coordinator = coordinator
        self._tranisitionContext = StateObject(wrappedValue: .init(rootRoute: rootRoute, delegate: coordinator, isRoot: isRoot, prevTransitionContext: prevTransitionContext))
    }
}

//
//  NavigationViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import SwiftUI

public struct NavigationViewContext<RouteType: Route,
                                    CoordinatorType: NavigationCoordinator>: Context where CoordinatorType.RouteType == RouteType {

    @StateObject
    public var tranisitionContext: NavigationViewTransitionContext<RouteType, CoordinatorType>

    private let coordinator: CoordinatorType

    public var body: some View {
        coordinator.prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
            .fullScreenCover(item: $tranisitionContext.fullScreenRoute) { route in
                Self(rootRoute: route,
                     coordinator: coordinator,
                     prevTransitionContext: tranisitionContext,
                     rootTransitionContext: tranisitionContext.rootTransitionContext)
            }
            .overlay {
                if let route = tranisitionContext.overlayRoute {
                    Self(rootRoute: route,
                         coordinator: coordinator,
                         prevTransitionContext: tranisitionContext,
                         rootTransitionContext: tranisitionContext.rootTransitionContext)
                }
            }
            .sheet(item: $tranisitionContext.sheetRoute) { route in
                Self(rootRoute: route,
                     coordinator: coordinator,
                     prevTransitionContext: tranisitionContext,
                     rootTransitionContext: tranisitionContext.rootTransitionContext)
            }
    }

    public init(rootRoute: RouteType,
                coordinator: CoordinatorType,
                prevTransitionContext: NavigationViewTransitionContext<RouteType, CoordinatorType>? = nil,
                rootTransitionContext: NavigationTransitionContext<RouteType, CoordinatorType>? = nil) {
        self.coordinator = coordinator
        self._tranisitionContext = StateObject(wrappedValue: .init(rootRoute: rootRoute,
                                                                   delegate: coordinator,
                                                                   prevTransitionContext: prevTransitionContext,
                                                                   rootTransitionContext: rootTransitionContext))
    }
}

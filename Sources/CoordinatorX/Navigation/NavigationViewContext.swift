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
        coordinator
            .prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
            .fullScreenCover(item: $tranisitionContext.fullScreenRoute) { transition in
                ZStack {
                    Self(rootRoute: transition.route,
                         coordinator: coordinator,
                         prevTransitionContext: tranisitionContext,
                         rootTransitionContext: tranisitionContext.rootTransitionContext)
                }
                .background(transition.backgroundColor)
                .transition(transition.style)
            }
#endif
            .overlay {
                if let transition = tranisitionContext.overlayRoute {
                    ZStack {
                        Self(rootRoute: transition.route,
                             coordinator: coordinator,
                             prevTransitionContext: tranisitionContext,
                             rootTransitionContext: tranisitionContext.rootTransitionContext)
                    }
                    .background(transition.backgroundColor)
                    .transition(transition.style)
                }
            }
            .sheet(item: $tranisitionContext.sheetRoute) { transition in
                ZStack {
                    Self(rootRoute: transition.route,
                         coordinator: coordinator,
                         prevTransitionContext: tranisitionContext,
                         rootTransitionContext: tranisitionContext.rootTransitionContext)
                }
                .background(transition.backgroundColor)
                .transition(transition.style)
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

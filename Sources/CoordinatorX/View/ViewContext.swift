//
//  ViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

public struct ViewContext<RouteType: Route,
                          CoordinatorType: ViewCoordinator>: Context where CoordinatorType.RouteType == RouteType {
    
    @StateObject
    public var tranisitionContext: ViewTransitionContext<RouteType, CoordinatorType>

    private let coordinator: CoordinatorType

    public var body: some View {
        coordinator.prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
            .fullScreenCover(item: $tranisitionContext.fullScreenRoute) { route in
                Self(rootRoute: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
            }
#endif
            .overlay {
                if let route = tranisitionContext.overlayRoute {
                    Self(rootRoute: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
                }
            }
            .sheet(item: $tranisitionContext.sheetRoute) { route in
                Self(rootRoute: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
            }
    }

    init(rootRoute: RouteType,
         coordinator: CoordinatorType,
         prevTransitionContext: ViewTransitionContext<RouteType, CoordinatorType>? = nil) {
        self.coordinator = coordinator
        self._tranisitionContext = StateObject(wrappedValue: .init(rootRoute: rootRoute, delegate: coordinator, prevTransitionContext: prevTransitionContext))
    }
}

//
//  ViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

public struct ViewContext<RouteType: Route,
                          CoordinatorType: ViewCoordinator>: Context where CoordinatorType.RouteType == RouteType {

    @State
    private var content: CoordinatorType.Content?

    @StateObject
    public var tranisitionContext: ViewTransitionContext<RouteType, CoordinatorType>

    private let coordinator: CoordinatorType

    public var body: some View {
        coordinator.prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
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

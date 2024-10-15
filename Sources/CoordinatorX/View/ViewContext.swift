//
//  ViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

public struct ViewContext<RouteType: Route, ViewBuilderType: Coordinator>: View where ViewBuilderType.RouteType == RouteType, ViewBuilderType.TransitionType == ViewTransitionType {

    @StateObject
    private var tranisitionContext: ViewTransitionContext<RouteType, ViewBuilderType>
    private let coordinator: ViewBuilderType

    public var body: some View {
        coordinator
            .prepareView(for: tranisitionContext.route, router: tranisitionContext)
            .fullScreenCover(item: $tranisitionContext.fullScreenCoverRoute) { route in
                Self(route: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
            }
            .overlay(overlay)
            .sheet(item: $tranisitionContext.sheetRoute) { route in
                Self(route: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
            }
    }

    @ViewBuilder
    private var overlay: some View {
        if let route = tranisitionContext.overlayRoute {
            Self(route: route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
        }
    }

    public init(route: RouteType, coordinator: ViewBuilderType, isRoot: Bool = false, prevTransitionContext: ViewTransitionContext<RouteType, ViewBuilderType>? = nil) {
        self.coordinator = coordinator
        self._tranisitionContext = StateObject(wrappedValue: .init(route: route, delegate: coordinator, isRoot: isRoot, prevTransitionContext: prevTransitionContext))
    }
}

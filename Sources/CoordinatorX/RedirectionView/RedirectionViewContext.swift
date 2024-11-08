//
//  RedirectionViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import SwiftUI

public struct RedirectionViewContext<RouteType: Route,
                                     CoordinatorType: RedirectionCoordinator>: Context where CoordinatorType.RouteType == RouteType {

    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var content: CoordinatorType.Content?


    @StateObject
    var tranisitionContext: RedirectionViewTransitionContext<RouteType, CoordinatorType>

    private let coordinator: CoordinatorType
    private let rootRoute: RouteType

    public var body: some View {
        coordinator
            .prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
            content
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
                .onReceive(tranisitionContext.dismissFlow) { _ in
                    presentationMode.wrappedValue.dismiss()
                }
    }

    init(rootRoute: RouteType, coordinator: CoordinatorType, isRoot: Bool = false, prevTransitionContext: RedirectionViewTransitionContext<RouteType, CoordinatorType>? = nil) {
        self.coordinator = coordinator
        _tranisitionContext = StateObject(wrappedValue: .init(rootRoute: rootRoute, delegate: coordinator, isRoot: isRoot, prevTransitionContext: prevTransitionContext))
        self.rootRoute = rootRoute
    }
}

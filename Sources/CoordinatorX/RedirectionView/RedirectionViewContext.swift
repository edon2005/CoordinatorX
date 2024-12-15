//
//  RedirectionViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import SwiftUI

public struct RedirectionViewContext<RouteType: Route,
                                     CoordinatorType: RedirectionCoordinator>: Context where CoordinatorType.RouteType == RouteType {

    @Environment(\.dismiss)
    private var dismiss

    @StateObject
    var tranisitionContext: RedirectionViewTransitionContext<RouteType, CoordinatorType>

    private let coordinator: CoordinatorType

    public var body: some View {
        coordinator
            .prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
            .fullScreenCover(item: $tranisitionContext.fullScreenRoute) { transition in
                ZStack {
                    Self(rootRoute: transition.route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
                }
                .background(transition.backgroundColor)
                .transition(transition.style)
            }
#endif
            .overlay {
                if let transition = tranisitionContext.overlayRoute {
                    ZStack {
                        Self(rootRoute: transition.route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
                    }
                    .background(transition.backgroundColor)
                    .transition(transition.style)
                }
            }
            .sheet(item: $tranisitionContext.sheetRoute) { transition in
                ZStack {
                    Self(rootRoute: transition.route, coordinator: coordinator, prevTransitionContext: tranisitionContext)
                }
                .background(transition.backgroundColor)
                .transition(transition.style)
            }
            .onReceive(tranisitionContext.dismissFlow) { _ in
                dismiss()
            }
            .background(coordinator.backgroundColor)
    }

    init(rootRoute: RouteType,
         coordinator: CoordinatorType,
         prevTransitionContext: RedirectionViewTransitionContext<RouteType, CoordinatorType>? = nil) {
        self.coordinator = coordinator
        _tranisitionContext = StateObject(wrappedValue: .init(rootRoute: rootRoute, delegate: coordinator, prevTransitionContext: prevTransitionContext))
    }
}

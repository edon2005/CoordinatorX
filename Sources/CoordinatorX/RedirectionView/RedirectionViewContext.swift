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
            .onReceive(tranisitionContext.dismissFlow) { _ in
                dismiss()
            }
    }

    init(rootRoute: RouteType,
         coordinator: CoordinatorType,
         prevTransitionContext: RedirectionViewTransitionContext<RouteType, CoordinatorType>? = nil) {
        self.coordinator = coordinator
        _tranisitionContext = StateObject(wrappedValue: .init(rootRoute: rootRoute, delegate: coordinator, prevTransitionContext: prevTransitionContext))
    }
}

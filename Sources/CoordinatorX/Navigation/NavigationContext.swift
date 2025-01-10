//
//  NavigationContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

@preconcurrency import Combine
import SwiftUI

public struct NavigationContext<RouteType: Route,
                                CoordinatorType: NavigationCoordinator>: Context where CoordinatorType.RouteType == RouteType {

    @StateObject
    public var tranisitionContext: NavigationTransitionContext<RouteType, CoordinatorType>

    @State
    private var isStatusBarHidden = false

    private let coordinator: CoordinatorType

    public var body: some View {
        NavigationStack(path: $tranisitionContext.path) {
            coordinator.prepareView(for: tranisitionContext.rootRoute, router: tranisitionContext)
                .navigationDestination(for: RouteType.self) { route in
                    NavigationViewContext(rootRoute: route, coordinator: coordinator, rootTransitionContext: tranisitionContext)
                }
                .background(TransparentBackground())
        }
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        .fullScreenCover(item: $tranisitionContext.fullScreenRoute) { transition in
            ZStack {
                NavigationViewContext(rootRoute: transition.route, coordinator: coordinator, rootTransitionContext: tranisitionContext)
            }
            .background(transition.backgroundColor)
            .transition(transition.style)
        }
#endif
        .overlay {
            if let transition = tranisitionContext.overlayRoute {
                ZStack {
                    NavigationViewContext(rootRoute: transition.route, coordinator: coordinator, rootTransitionContext: tranisitionContext)
                }
                .background(transition.backgroundColor)
                .transition(transition.style)
            }
        }
        .sheet(item: $tranisitionContext.sheetRoute) { transition in
            ZStack {
                NavigationViewContext(rootRoute: transition.route, coordinator: coordinator, rootTransitionContext: tranisitionContext)
            }
            .background(transition.backgroundColor)
            .transition(transition.style)
        }
        .onPreferenceChange(NavStatusBarHiddenKey.self) { [$isStatusBarHidden] value in
            guard let value else { return }
            $isStatusBarHidden.wrappedValue = value
        }
        .statusBar(hidden: isStatusBarHidden)
    }

    init(rootRoute: RouteType,
         coordinator: CoordinatorType) {
        self.coordinator = coordinator
        self._tranisitionContext = StateObject(wrappedValue: .init(rootRoute: rootRoute, delegate: coordinator, prevTransitionContext: nil))
    }
}

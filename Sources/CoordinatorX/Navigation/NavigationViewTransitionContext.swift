//
//  NavigationViewTransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import Foundation

public final class NavigationViewTransitionContext<RouteType: Route, CoordinatorType: NavigationCoordinator>: TransitionContext where RouteType == CoordinatorType.RouteType {

    @Published
    var rootRoute: RouteType

    @Published
    var fullScreenRoute: RouteType?

    @Published
    var overlayRoute: RouteType?

    @Published
    var sheetRoute: RouteType?

    nonisolated(unsafe) var onDeinit: (() -> Void)?

    var delegate: CoordinatorType?
    var nextTransitionContext: NavigationViewTransitionContext?
    var prevTransitionContext: NavigationViewTransitionContext?
    var rootTransitionContext: NavigationTransitionContext<RouteType, CoordinatorType>?

    private var isRoot: Bool

    required init(rootRoute: RouteType, delegate: CoordinatorType?, prevTransitionContext: NavigationViewTransitionContext<RouteType, CoordinatorType>?) {
        self.rootRoute = rootRoute
        self.delegate = delegate
        self.prevTransitionContext = prevTransitionContext
        self.isRoot = prevTransitionContext == nil
        self.prevTransitionContext?.nextTransitionContext = self
    }

    convenience init(rootRoute: RouteType,
                     delegate: CoordinatorType?,
                     prevTransitionContext: NavigationViewTransitionContext? = nil,
                     rootTransitionContext: NavigationTransitionContext<RouteType, CoordinatorType>?) {
        self.init(rootRoute: rootRoute, delegate: delegate, prevTransitionContext: prevTransitionContext)
        self.rootTransitionContext = rootTransitionContext
    }

    deinit {
        onDeinit?()
    }

    public func trigger(_ route: RouteType) {
        guard let transition = delegate?.prepareTransition(for: route) else { return }
        handleTransition(route: route, transition: transition, delegate: delegate)
    }

    private func dismiss() {
        prevTransitionContext?.sheetRoute = nil
        prevTransitionContext?.overlayRoute = nil
        prevTransitionContext?.fullScreenRoute = nil
    }

    func getRootContext() -> NavigationViewTransitionContext<RouteType, CoordinatorType>? {
        isRoot ? self : prevTransitionContext?.getRootContext()
    }

    private func handleMultipleTransitions(_ route: RouteType, _ values: [NavigationTransition]) {
        values.forEach { value in
            handleTransition(route: route, transition: value, delegate: delegate)
        }
    }

    private func handleTransition(route: RouteType,
                                  transition: CoordinatorType.TransitionType,
                                  delegate: CoordinatorType?) {
        switch transition {
        case .dismiss: dismiss()
        case .fullScreen: setFullScreenRoute(route)
        case .multiple(let values): handleMultipleTransitions(route, values)
        case .none: break
        case .overlay: setOverlayRoute(route)
        case .pop: handlePop()
        case .popToRoot: handlePopToRoot()
        case .push: handlePush(route)
        case .root: setRootRoute(route)
        case .set: setRoute(route)
        case .sheet: setSheetRoute(route)
        }
    }

    private func handlePop() {
        rootTransitionContext?.handlePop()
    }

    private func handlePopToRoot() {
        rootTransitionContext?.handlePopToRoot()
    }

    private func handlePush(_ route: RouteType) {
        rootTransitionContext?.handlePush(route)
    }
}

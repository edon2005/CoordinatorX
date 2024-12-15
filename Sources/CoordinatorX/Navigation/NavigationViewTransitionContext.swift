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

#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    @Published
    var fullScreenRoute: Transition<RouteType>?
#endif

    @Published
    var overlayRoute: Transition<RouteType>?

    @Published
    var sheetRoute: Transition<RouteType>?

    nonisolated(unsafe) var onDeinit: (() -> Void)?

    var delegate: CoordinatorType?
    weak var nextTransitionContext: NavigationViewTransitionContext?
    weak var prevTransitionContext: NavigationViewTransitionContext?
    weak var rootTransitionContext: NavigationTransitionContext<RouteType, CoordinatorType>?

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
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        prevTransitionContext?.fullScreenRoute = nil
#endif
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
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        case .fullScreen(let options): setFullScreenRoute(route, options: options)
#endif
        case .multiple(let values): handleMultipleTransitions(route, values)
        case .none: break
        case .overlay(let options): setOverlayRoute(route, options: options)
        case .pop: handlePop()
        case .popToRoot: handlePopToRoot()
        case .push: handlePush(route)
        case .root: setRootRoute(route)
        case .set: setRoute(route)
        case .sheet(let options): setSheetRoute(route, options: options)
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

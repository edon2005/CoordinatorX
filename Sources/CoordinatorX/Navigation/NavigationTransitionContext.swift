//
//  NavigationTransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import Foundation

public final class NavigationTransitionContext<RouteType: Route,
                                               CoordinatorType: NavigationCoordinator>: TransitionContext where RouteType == CoordinatorType.RouteType {
    @Published
    var rootRoute: RouteType

#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    @Published
    var fullScreenRoute: RouteType?
#endif

    @Published
    var overlayRoute: RouteType?

    @Published
    var sheetRoute: RouteType?

    @Published
    var path: [RouteType] = []

    nonisolated(unsafe) var onDeinit: (() -> Void)?

    var delegate: CoordinatorType?
    weak var nextTransitionContext: NavigationTransitionContext?
    weak var prevTransitionContext: NavigationTransitionContext?

    private var isRoot: Bool

    required init(rootRoute: RouteType, delegate: CoordinatorType?, prevTransitionContext: NavigationTransitionContext? = nil) {
        self.rootRoute = rootRoute
        self.delegate = delegate
        self.prevTransitionContext = prevTransitionContext
        self.isRoot = prevTransitionContext == nil
        self.prevTransitionContext?.nextTransitionContext = self
    }

    deinit {
        onDeinit?()
    }

    public func trigger(_ route: RouteType) {
        guard let transition = delegate?.prepareTransition(for: route) else { return }
        handleTransition(route: route, transition: transition)
    }

    private func dismiss() {
        prevTransitionContext?.sheetRoute = nil
        prevTransitionContext?.overlayRoute = nil
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        prevTransitionContext?.fullScreenRoute = nil
#endif
    }

    private func handleMultipleTransitions(_ route: RouteType, _ values: [NavigationTransition]) {
        values.forEach { value in
            handleTransition(route: route, transition: value)
        }
    }

    func handlePop() {
        guard path.isEmpty == false else { return }
        path.removeLast()
    }

    func handlePopToRoot() {
        guard path.isEmpty == false else { return }
        path.removeAll()
    }

    func handlePush(_ route: RouteType) {
        path.append(route)
    }

    private func handleTransition(route: RouteType, transition: NavigationTransition) {
        switch transition {
        case .dismiss: dismiss()
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        case .fullScreen: setFullScreenRoute(route)
#endif
        case .multiple(let values): handleMultipleTransitions(route, values)
        case .none: break
        case .overlay: setOverlayRoute(route)
        case .pop: handlePop()
        case .popToRoot: handlePopToRoot()
        case .root: setRootRoute(route)
        case .set: setRoute(route)
        case .sheet: setSheetRoute(route)
        case .push: handlePush(route)
        }
    }
}

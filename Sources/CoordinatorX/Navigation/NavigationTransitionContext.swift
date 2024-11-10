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

    @Published
    var fullScreenRoute: RouteType?

    @Published
    var overlayRoute: RouteType?

    @Published
    var sheetRoute: RouteType?

    @Published
    var path: [RouteType] = []

    nonisolated(unsafe) var onDeinit: (() -> Void)?

    weak var delegate: CoordinatorType?
    weak var nextTransitionContext: NavigationTransitionContext?
    weak var prevTransitionContext: NavigationTransitionContext?

    private var isRoot: Bool

    required init(rootRoute: RouteType, delegate: CoordinatorType?, isRoot: Bool = false, prevTransitionContext: NavigationTransitionContext? = nil) {
        self.rootRoute = rootRoute
        self.delegate = delegate
        self.prevTransitionContext = prevTransitionContext
        self.isRoot = isRoot
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
        prevTransitionContext?.fullScreenRoute = nil
    }

    func getRootContext() -> NavigationTransitionContext<RouteType, CoordinatorType>? {
        isRoot ? self : prevTransitionContext?.getRootContext()
    }

    private func handleMultipleTransitions(_ route: RouteType, _ values: [NavigationTransitionType]) {
        values.forEach { value in
            handleTransition(route: route, transition: value)
        }
    }

    private func handlePop() {
        guard path.isEmpty == false else { return }
        path.removeLast()
    }

    private func handlePopToRoot() {
        guard path.isEmpty == false else { return }
        path.removeAll()
    }

    private func handlePush(_ route: RouteType) {
        path.append(route)
    }

    private func handleTransition(route: RouteType, transition: NavigationTransitionType) {
        switch transition {
        case .dismiss: dismiss()
        case .fullScreen: setFullScreenRoute(route)
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

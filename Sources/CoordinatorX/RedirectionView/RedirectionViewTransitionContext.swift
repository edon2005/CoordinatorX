//
//  RedirectionViewTransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import Combine
import Foundation

final class RedirectionViewTransitionContext<RouteType: Route,
                                             CoordinatorType: RedirectionCoordinator>: TransitionContext where RouteType == CoordinatorType.RouteType {
    
    @Published
    public var rootRoute: RouteType

    @Published
    public var fullScreenRoute: RouteType?

    @Published
    public var overlayRoute: RouteType?

    @Published
    public var sheetRoute: RouteType?

    var dismissFlow = PassthroughSubject<Void, Never>()
    nonisolated(unsafe) var onDeinit: (() -> Void)?

    weak var prevTransitionContext: RedirectionViewTransitionContext?
    weak var nextTransitionContext: RedirectionViewTransitionContext?
    weak var delegate: CoordinatorType?

    private var isRoot: Bool

    required public init(rootRoute: RouteType,
                         delegate: CoordinatorType?,
                         prevTransitionContext: RedirectionViewTransitionContext? = nil) {
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
        handleTrigger(route: route, transition: transition, delegate: delegate, parentRouter: delegate?.parentRouter)
    }

    private func handleTrigger(route: RouteType,
                               transition: CoordinatorType.TransitionType,
                               delegate: CoordinatorType?,
                               parentRouter: (any Router<CoordinatorType.ParentRouteType>)?) {
        switch transition {
        case .dismiss: dismiss()
        case .dismissToRoot: dismissToRoot()
        case .fullScreen: setFullScreenRoute(route)
        case .multiple(let values): handleMultipleTransitions(route, values)
        case .none: break
        case .overlay: setOverlayRoute(route)
        case .parent(let parentRoute): handleParent(route: parentRoute, parentRouter: parentRouter)
        case .root: setRootRoute(route)
        case .set: setRoute(route)
        case .sheet: setSheetRoute(route)
        }
    }

    private func dismiss() {
        if isRoot {
            dismissFlow.send()
        } else {
            prevTransitionContext?.sheetRoute = nil
            prevTransitionContext?.overlayRoute = nil
            prevTransitionContext?.fullScreenRoute = nil
        }
    }

    private func dismissToRoot() {
        guard let context = getRootContext() else { return }
        context.sheetRoute = nil
        context.overlayRoute = nil
        context.fullScreenRoute = nil
    }

    private func handleMultipleTransitions(_ route: RouteType, _ values: [RedirectionViewTransitionType<CoordinatorType.ParentRouteType>]) {
        values.forEach { value in
            handleTrigger(route: route, transition: value, delegate: delegate, parentRouter: delegate?.parentRouter)
        }
    }

    private func handleParent(route: CoordinatorType.ParentRouteType, parentRouter: (any Router<CoordinatorType.ParentRouteType>)?) {
        parentRouter?.parentRouter?.trigger(route)
    }
}

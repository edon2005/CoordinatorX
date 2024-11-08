//
//  RedirectionViewTransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import Combine
import Foundation

final class RedirectionViewTransitionContext<RouteType: Route, CoordinatorType: RedirectionCoordinator>: TransitionContext where RouteType == CoordinatorType.RouteType {

    @Published
    public var rootRoute: RouteType

    @Published
    public var fullScreenRoute: RouteType?

    @Published
    public var overlayRoute: RouteType?

    @Published
    public var sheetRoute: RouteType?

    public var dismissFlow = PassthroughSubject<Void, Never>()

    weak var prevTransitionContext: RedirectionViewTransitionContext?
    weak var nextTransitionContext: RedirectionViewTransitionContext?
    weak var delegate: CoordinatorType?

    private var isRoot: Bool

    required public init(rootRoute: RouteType,
                         delegate: CoordinatorType?,
                         isRoot: Bool = false,
                         prevTransitionContext: RedirectionViewTransitionContext? = nil) {
        self.rootRoute = rootRoute
        self.delegate = delegate
        self.prevTransitionContext = prevTransitionContext
        self.isRoot = isRoot
        self.prevTransitionContext?.nextTransitionContext = self
    }

    deinit {
    }

    public func trigger(_ route: RouteType) {
        guard let transition = delegate?.prepareTransition(for: route) else { return }
        contextTrigger(route: route, transition: transition, delegate: delegate, parentRouter: delegate?.parentRouter)
    }

    private func contextTrigger(route: RouteType,
                                transition: CoordinatorType.TransitionType,
                                delegate: CoordinatorType?,
                                parentRouter: (any Router<CoordinatorType.ParentRouteType>)?) {
        switch transition {
        case .dismiss: dismiss()
        case .dismissToRoot: dismissToRoot()
        case .fullScreen: self.fullScreenRoute = route
        case let .multiple(value):
            value.forEach { value in
                self.contextTrigger(route: route, transition: value, delegate: delegate, parentRouter: parentRouter)
            }
        case .none: break
        case .overlay: self.overlayRoute = route
        case .parent(let parentRoute): break; // parentRouter?.parentRouter?.trigger(parentRoute)
        case .root: self.getRootContext()?.rootRoute = route
        case .set: self.rootRoute = route
        case .sheet: self.sheetRoute = route
        }
    }

    private func getRootContext() -> RedirectionViewTransitionContext<RouteType, CoordinatorType>? {
        isRoot ? self : prevTransitionContext?.getRootContext()
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
}

extension Router where Self: TransitionContext {
    var parentRouter: (any Router<RouteType>)? {
        return prevTransitionContext
    }
}

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

#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    @Published
    public var fullScreenRoute: RouteType?
#endif

    @Published
    public var overlayRoute: RouteType?

    @Published
    public var sheetRoute: RouteType?

    var dismissFlow = PassthroughSubject<Void, Never>()
    nonisolated(unsafe) var onDeinit: (() -> Void)?

    var delegate: CoordinatorType?
    weak var nextTransitionContext: RedirectionViewTransitionContext?
    weak var prevTransitionContext: RedirectionViewTransitionContext?

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
        handleTransition(route: route, transition: transition, delegate: delegate, parentRouter: delegate?.parentRouter)
    }

    private func dismiss() {
        if isRoot {
            dismissFlow.send()
        } else {
            prevTransitionContext?.sheetRoute = nil
            prevTransitionContext?.overlayRoute = nil
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
            prevTransitionContext?.fullScreenRoute = nil
#endif
        }
    }

    @discardableResult
    private func dismissToRoot() -> Int {
        var result = 0
        if #available(iOS 16.4, *) {
            guard let context = getRootContext() else { return result }
            context.sheetRoute = nil
            context.overlayRoute = nil
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
            context.fullScreenRoute = nil
#endif
        } else {
            var context = self.prevTransitionContext
            var count = 0
            while context != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(count * 350)) { [context] in
                    context?.sheetRoute = nil
                    context?.overlayRoute = nil
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
                    context?.fullScreenRoute = nil
#endif
                }
                count += 1
                context = context?.prevTransitionContext
            }
            result = count
        }
        return result
    }

    private func handleMultipleTransitions(route: RouteType,
                                           transitions values: [RedirectionViewTransition<CoordinatorType.ParentRouteType>],
                                           delegate: CoordinatorType?,
                                           parentRouter: (any Router<CoordinatorType.ParentRouteType>)?) {
        values.forEach { value in
            handleTransition(route: route, transition: value, delegate: delegate, parentRouter: delegate?.parentRouter)
        }
    }

    private func handleParent(route: CoordinatorType.ParentRouteType, parentRouter: (any Router<CoordinatorType.ParentRouteType>)?) {
        if #available(iOS 16.4, *) {
            parentRouter?.parentRouter?.trigger(route)
        } else {
            let count = dismissToRoot()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(count * 400)) {
                parentRouter?.parentRouter?.trigger(route)
            }
        }
    }

    private func handleTransition(route: RouteType,
                                  transition: CoordinatorType.TransitionType,
                                  delegate: CoordinatorType?,
                                  parentRouter: (any Router<CoordinatorType.ParentRouteType>)?) {
        switch transition {
        case .dismiss: dismiss()
        case .dismissToRoot: dismissToRoot()
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        case .fullScreen: setFullScreenRoute(route)
#endif
        case .multiple(let values): handleMultipleTransitions(route: route, transitions: values, delegate: delegate, parentRouter: parentRouter)
        case .none: break
        case .overlay: setOverlayRoute(route)
        case .parent(let parentRoute): handleParent(route: parentRoute, parentRouter: parentRouter)
        case .root: setRootRoute(route)
        case .set: setRoute(route)
        case .sheet: setSheetRoute(route)
        }
    }
}

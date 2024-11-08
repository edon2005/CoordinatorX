//
//  ViewTransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import Foundation

public final class ViewTransitionContext<RouteType: Route, CoordinatorType: ViewCoordinator>: TransitionContext where RouteType == CoordinatorType.RouteType {

    @Published
    public var rootRoute: RouteType

    @Published
    public var fullScreenRoute: RouteType?

    @Published
    public var overlayRoute: RouteType?

    @Published
    public var sheetRoute: RouteType?

    weak var prevTransitionContext: ViewTransitionContext?
    weak var parentRouter: (any Router<RouteType>)? {
        prevTransitionContext
    }
    weak public var nextTransitionContext: ViewTransitionContext?

    weak var delegate: CoordinatorType?

    nonisolated(unsafe) var onDeinit: (() -> Void)?

    private var isRoot: Bool


    required public init(rootRoute: RouteType, delegate: CoordinatorType?, isRoot: Bool = false, prevTransitionContext: ViewTransitionContext? = nil) {
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
        contextTrigger(route: route, transition: transition)
    }

    private func contextTrigger(route: RouteType, transition: ViewTransitionType) {
        switch transition {
        case .dismiss: dismiss()
        case .fullScreen: setFullScreenRoute(route)
        case let .multiple(value):
            value.forEach { value in
                self.contextTrigger(route: route, transition: value)
            }
        case .none: break
        case .overlay: setOverlayRoute(route)
        case .root: self.getRootContext()?.rootRoute = route
        case .set: self.rootRoute = route
        case .sheet: setSheetRoute(route)
        }
    }

    private func dismiss() {
        prevTransitionContext?.sheetRoute = nil
        prevTransitionContext?.overlayRoute = nil
        prevTransitionContext?.fullScreenRoute = nil
    }

    private func getRootContext() -> ViewTransitionContext<RouteType, CoordinatorType>? {
        isRoot ? self : prevTransitionContext?.getRootContext()
    }

    private func setFullScreenRoute(_ route: RouteType) {
        let onDeinit: () -> Void = {
            Task {
                self.fullScreenRoute = route
            }
        }

        if sheetRoute != nil {
            nextTransitionContext?.onDeinit = onDeinit
            fullScreenRoute = nil
        } else if self.fullScreenRoute != nil  {
            nextTransitionContext?.onDeinit = onDeinit
            self.fullScreenRoute = nil
        } else {
            self.fullScreenRoute = route
        }
    }

    private func setOverlayRoute(_ route: RouteType) {
        overlayRoute = route
    }

    private func setSheetRoute(_ route: RouteType) {
        let onDeinit: () -> Void = {
            Task {
                self.sheetRoute = route
            }
        }

        if fullScreenRoute != nil {
            nextTransitionContext?.onDeinit = onDeinit
            fullScreenRoute = nil
        } else if self.sheetRoute != nil  {
            nextTransitionContext?.onDeinit = onDeinit
            self.sheetRoute = nil
        } else {
            self.sheetRoute = route
        }
    }
}

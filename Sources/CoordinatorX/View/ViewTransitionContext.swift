//
//  ViewTransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import Foundation

public final class ViewTransitionContext<RouteType: Route, CoordinatorType: ViewCoordinator>: TransitionContext where RouteType == CoordinatorType.RouteType {

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

    nonisolated(unsafe) var onDeinit: (() -> Void)?

    var delegate: CoordinatorType?
    weak var nextTransitionContext: ViewTransitionContext?
    weak var prevTransitionContext: ViewTransitionContext?

    private var isRoot: Bool

    required init(rootRoute: RouteType, delegate: CoordinatorType?, prevTransitionContext: ViewTransitionContext? = nil) {
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
        handleTransition(route: route, transition: transition, delegate: delegate)
    }

    private func dismiss() {
        prevTransitionContext?.sheetRoute = nil
        prevTransitionContext?.overlayRoute = nil
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        prevTransitionContext?.fullScreenRoute = nil
#endif
    }

    private func handleMultipleTransitions(_ route: RouteType, _ values: [ViewTransition]) {
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
        case .fullScreen: setFullScreenRoute(route)
#endif
        case .multiple(let values): handleMultipleTransitions(route, values)
        case .none: break
        case .overlay: setOverlayRoute(route)
        case .root: setRootRoute(route)
        case .set: setRoute(route)
        case .sheet: setSheetRoute(route)
        }
    }
}

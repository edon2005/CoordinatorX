//
//  ViewTransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import Foundation

public class ViewTransitionContext<RouteType: Route, CoordinatorType: Coordinator>: ObservableObject, Router where RouteType == CoordinatorType.RouteType, CoordinatorType.TransitionType == ViewTransitionType {

    @Published
    var route: RouteType

    @Published
    var fullScreenCoverRoute: RouteType?

    @Published
    var overlayRoute: RouteType?

    @Published
    var sheetRoute: RouteType?

    weak var prevTransitionContext: ViewTransitionContext<RouteType, CoordinatorType>?

    private weak var delegate: CoordinatorType?
    private var isRoot: Bool

    init(route: RouteType, delegate: CoordinatorType?, isRoot: Bool = false, prevTransitionContext: ViewTransitionContext<RouteType, CoordinatorType>? = nil) {
        self.route = route
        self.delegate = delegate
        self.prevTransitionContext = prevTransitionContext
        self.isRoot = isRoot
    }

    public func trigger(_ route: RouteType) {
        guard let transition = delegate?.prepareTransition(for: route) else { return }
        switch transition {
        case .fullScreen: self.fullScreenCoverRoute = route
        case .none: break
        case .overlay: self.overlayRoute = route
        case .parent: break
        case .root: self.getRootContext()?.route = route
        case .set: self.route = route
        case .sheet: self.sheetRoute = route
        }
    }

    private func getRootContext() -> ViewTransitionContext<RouteType, CoordinatorType>? {
        isRoot ? self : prevTransitionContext?.getRootContext()
    }
}

extension ViewTransitionContext where CoordinatorType: RedirectionCoordinator, RouteType == CoordinatorType.RouteType, CoordinatorType.TransitionType == ViewTransitionType, CoordinatorType.ParentRouteType: Route {
    public func trigger(_ route: RouteType) {
        print("Redirection")
    }
}

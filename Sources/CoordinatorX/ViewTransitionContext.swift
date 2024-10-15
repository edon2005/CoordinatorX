//
//  ViewTransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import Foundation

class ViewTransitionContext<RouteType: Route, ViewBuilder: Coordinator>: ObservableObject, Router where RouteType == ViewBuilder.RouteType, ViewBuilder.TransitionType == ViewTransitionType {

    @Published
    var route: RouteType

    @Published
    var fullScreenCoverRoute: RouteType?

    @Published
    var overlayRoute: RouteType?

    @Published
    var sheetRoute: RouteType?

    weak var prevTransitionContext: ViewTransitionContext<RouteType, ViewBuilder>?

    private weak var delegate: ViewBuilder?
    private var isRoot: Bool

    init(route: RouteType, delegate: ViewBuilder?, isRoot: Bool = false, prevTransitionContext: ViewTransitionContext<RouteType, ViewBuilder>? = nil) {
        self.route = route
        self.delegate = delegate
        self.prevTransitionContext = prevTransitionContext
        self.isRoot = isRoot
    }

    func trigger(_ route: RouteType) {
        if let transition = delegate?.prepareTransition(for: route) {
            switch transition {
            case .none: break
            case .root:
                self.getRootContext()?.route = route

            case .set:
                self.route = route

            case .sheet:
                sheetRoute = route
            }
        }
    }

    private func getRootContext() -> ViewTransitionContext<RouteType, ViewBuilder>? {
        isRoot ? self : prevTransitionContext?.getRootContext()
    }
}

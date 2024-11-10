//
//  TransitionContext + Parent.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

extension Router {
    var parentRouter: (any Router<RouteType>)? {
        (self as? (any TransitionContext))?.prevTransitionContext as? Self
    }
}

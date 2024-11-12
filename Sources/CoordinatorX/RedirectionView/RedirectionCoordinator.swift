//
//  RedirectionCoordinator.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 26/10/2024.
//

import Foundation

public protocol RedirectionCoordinator: Coordinator where TransitionType == RedirectionViewTransition<ParentRouteType>  {
    associatedtype ParentRouteType: Route

    var parentRouter: (any Router<ParentRouteType>) { get }
}

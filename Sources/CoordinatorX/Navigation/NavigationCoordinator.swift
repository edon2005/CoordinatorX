//
//  NavigationCoordinator.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

public protocol NavigationCoordinator: Coordinator where TransitionType == NavigationTransition {

    @MainActor
    var activeRoute: RouteType? { get set }

}

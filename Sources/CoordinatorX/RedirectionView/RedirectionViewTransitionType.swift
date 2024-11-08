//
//  RedirectionViewTransitionType.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import Foundation

public enum RedirectionViewTransitionType<ParentRouteType: Route>: TransitionTypeProtocol {

    case dismiss
    case dismissToRoot
    case fullScreen
    case multiple([Self])
    case none
    case overlay
    case parent(ParentRouteType)
    case root
    case set
    case sheet

    public static func multiple(_ transition: Self...) -> Self {
        .multiple(transition)
    }
}

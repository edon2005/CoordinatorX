//
//  NavigationTransition.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

public enum NavigationTransition: TransitionTypeProtocol, Equatable {

    case dismiss
    case fullScreen
    case multiple([Self])
    case none
    case overlay
    case pop
    case popToRoot
    case push
    case root
    case set
    case sheet

    public static func multiple(_ transition: Self...) -> Self {
        .multiple(transition)
    }
}

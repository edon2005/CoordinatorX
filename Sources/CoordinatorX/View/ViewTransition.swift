//
//  ViewTransition.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

public enum ViewTransition: TransitionTypeProtocol, Equatable {

    case dismiss
    case fullScreen
    case multiple([Self])
    case none
    case overlay
    case root
    case set
    case sheet

    public static func multiple(_ transition: Self...) -> Self {
        .multiple(transition)
    }
}

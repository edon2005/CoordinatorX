//
//  ViewTransition.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

public enum ViewTransition: TransitionTypeProtocol {

    case dismiss
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    case fullScreen([TransitionOptions])
#endif
    case multiple([Self])
    case none
    case overlay([TransitionOptions])
    case root
    case set
    case sheet([TransitionOptions])

    public static func multiple(_ transitions: Self...) -> Self {
        .multiple(transitions)
    }

#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    public static func fullScreen(_ options: TransitionOptions...) -> Self {
        .fullScreen(options)
    }

    public static var fullScreen: Self { .fullScreen() }
#endif

    public static func overlay(_ options: TransitionOptions...) -> Self {
        .overlay(options)
    }

    public static var overlay: Self { .sheet() }

    public static func sheet(_ options: TransitionOptions...) -> Self {
        .sheet(options)
    }

    public static var sheet: Self { .sheet() }
}

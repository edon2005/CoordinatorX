//
//  ViewTransitionType.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

enum ViewTransitionType: TransitionTypeProtocol {

//    case dismissModal
//    case dismissOverlay
//    case dismissToParent
//    case modal(any View)
    case none
//    case overlay(any View)
//    case pop
//    case popToRoot
//    case push(any View)
    case root
    case set
    case sheet
}

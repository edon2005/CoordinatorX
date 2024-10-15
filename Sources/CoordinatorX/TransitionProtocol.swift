//
//  TransitionProtocol.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

protocol TransitionProtocol {
    associatedtype RouteType: Route
    associatedtype TransitionType: TransitionTypeProtocol
    var type: TransitionType { get }
    var route: RouteType { get }
}

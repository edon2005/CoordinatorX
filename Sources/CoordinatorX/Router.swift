//
//  Router.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

@MainActor
protocol Router<RouteType>: AnyObject, Sendable {
    associatedtype RouteType: Route

    func trigger(_ route: RouteType)
}

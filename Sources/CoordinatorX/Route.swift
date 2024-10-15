//
//  Route.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

public protocol Route: Identifiable, Hashable {}

public extension Route {
    var id: String {
        String(describing: self)
    }
}

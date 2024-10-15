//
//  Route.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

protocol Route: Identifiable, Hashable {}

extension Route {
    var id: String {
        String(describing: self)
    }
}

//
//  Coordinator.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

protocol Coordinator: AnyObject {
    associatedtype RouteType: Route
    associatedtype Content: View
    associatedtype TransitionType: TransitionTypeProtocol

    var initialRoute: RouteType { get set }

    @MainActor
    func prepareView(for route: RouteType, router: any Router<RouteType>) -> Content

    @MainActor
    func prepareTransition(for route: RouteType) -> TransitionType
}

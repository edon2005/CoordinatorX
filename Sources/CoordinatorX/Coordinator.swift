//
//  Coordinator.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

public protocol Coordinator: AnyObject {

    associatedtype Content: View
    associatedtype RouteType: Route
    associatedtype TransitionType: TransitionTypeProtocol

    var backgroundColor: Color { get }
    var initialRoute: RouteType { get set }

    @MainActor
    func prepareTransition(for route: RouteType) -> TransitionType

    @MainActor
    func prepareView(for route: RouteType, router: any Router<RouteType>) -> Content

}

extension Coordinator {

    public var backgroundColor: Color { .clear }

}

//
//  Transition.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 17/12/2024.
//

import SwiftUI

struct Transition<RouteType: Route> {
    let route: RouteType
    let backgroundColor: Color
    let style: AnyTransition
}

extension Transition: Identifiable {
    var id: String { route.id }
}

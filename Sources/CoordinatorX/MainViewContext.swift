//
//  MainViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

struct MainViewContext<RouteType: Route, ViewBuilderType: Coordinator>: View where ViewBuilderType.RouteType == RouteType, ViewBuilderType.TransitionType == ViewTransitionType {

    let coordinator: ViewBuilderType

    var body: some View {
        ViewContext(route: coordinator.initialRoute, coordinator: coordinator, isRoot: true)
    }
}

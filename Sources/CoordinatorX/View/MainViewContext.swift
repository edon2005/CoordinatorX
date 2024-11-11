//
//  MainViewContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

public struct MainViewContext<CoordinatorType: ViewCoordinator>: View {
    let coordinator: CoordinatorType
}

public extension MainViewContext {
    var body: some View {
        ViewContext(rootRoute: coordinator.initialRoute, coordinator: coordinator)
    }
}

//
//  CoordinatorX-ExampleApp.swift
//  CoordinatorX-Example
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

@main
struct CoordinatorX_ExampleApp: App {

    private let coordinator = AppCoordinator(initialRoute: .splash)

    var body: some Scene {
        WindowGroup {
            AppFlow(coordinator: coordinator)
                .background(.black)
        }
    }
}

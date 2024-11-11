//
//  DefaultNavigationFlow.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import SwiftUI

public protocol DefaultNavigationFlow: DefaultFlow where CoordinatorType: NavigationCoordinator {}

public extension DefaultNavigationFlow {
    var body: some View {
        MainNavigationContext(coordinator: coordinator)
    }
}

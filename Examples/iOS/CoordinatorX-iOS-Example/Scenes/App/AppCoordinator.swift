//
//  AppCoordinator.swift
//  SIC
//
//  Created by Yevhen Don on 12/10/2024.
//

import CoordinatorX
import SwiftUI

final class AppCoordinator: ViewCoordinator {

    var initialRoute: AppRoute

    init(initialRoute: AppRoute) {
        self.initialRoute = initialRoute
    }

    @MainActor
    func prepareTransition(for route: AppRoute) -> ViewTransition {
        switch route {
        case .splash: .root
        case .onboarding: .root
        case .home: .root
        }
    }

    @MainActor
    @ViewBuilder
    func prepareView(for route: AppRoute, router: any Router<AppRoute>) -> some View {
        switch route {
        case .splash:
            lazy var viewModel = SplashViewModel(router: router)
            SplashView(viewModel: viewModel)

        case .onboarding:
            lazy var coordinator = OnboardingCoordinator(initialRoute: .intro, parentRouter: router)
            OnboardingFlow(coordinator: coordinator)

        case .home:
            lazy var coordinator = HomeCoordinator(initialRoute: .main)
            HomeFlow(coordinator: coordinator)
                .transition(.push(from: .trailing))
        }
    }
}

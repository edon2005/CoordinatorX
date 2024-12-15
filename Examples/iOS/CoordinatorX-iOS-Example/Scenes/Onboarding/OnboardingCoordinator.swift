//
//  OnboardingCoordinator.swift
//  CoordinatorX-Example
//
//  Created by Yevhen Don on 15/10/2024.
//

import CoordinatorX
import SwiftUI

final class OnboardingCoordinator: RedirectionCoordinator {

    var initialRoute: OnboardingRoute
    var parentRouter: (any Router<AppRoute>)

    init(initialRoute: OnboardingRoute, parentRouter: (any Router<AppRoute>)) {
        self.initialRoute = initialRoute
        self.parentRouter = parentRouter
    }

    @MainActor
    func prepareTransition(for route: OnboardingRoute) -> RedirectionViewTransition<AppRoute> {
        switch route {
        case .intro: .root
        case .stepOne: .set // in this particular case set and root do the same. If prev context would be sheet/fullscreen/overlay the behaviroud would be different
        case .home: .parent(.home)
        }
    }

    @MainActor
    @ViewBuilder
    func prepareView(for route: OnboardingRoute, router: any Router<OnboardingRoute>) -> some View {
        switch route {
        case .intro:
            lazy var viewModel = OnboardingIntroViewModel(onboardRouter: router)
            OnboardingIntroView(viewModel: viewModel)
                .transition(.asymmetric(insertion: .opacity, removal: .push(from: .trailing)))

        case .stepOne:
            lazy var viewModel = OnboardingStepOneViewModel(onboardRouter: router)
            OnboardingStepOneView(viewModel: viewModel)
                .transition(.push(from: .trailing))

        default: EmptyView() // We dont have view for login in this flow, Login will be hadnled by parent coordinator. So here we keep just Empty.
        }
    }
}

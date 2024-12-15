//
//  OnbosrdingMainViewModel.swift
//  CoordinatorX-iOS-Example
//
//  Created by Yevhen Don on 16/12/2024.
//

import Foundation
import CoordinatorX

@MainActor
final class OnboardingIntroViewModel {

    private weak var onboardRouter: (any Router<OnboardingRoute>)?
    private weak var homeRouter: (any Router<HomeRoute>)?

    init(onboardRouter: (any Router<OnboardingRoute>)? = nil,
         homeRouter: (any Router<HomeRoute>)? = nil) {
        self.onboardRouter = onboardRouter
        self.homeRouter = homeRouter
    }

    func routeToNextScreen() {
        onboardRouter?.trigger(.stepOne)
        homeRouter?.trigger(.stepOne)
    }
}

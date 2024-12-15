//
//  OnboardingStepOneViewModel.swift
//  CoordinatorX-iOS-Example
//
//  Created by Yevhen Don on 17/12/2024.
//

import CoordinatorX
import Foundation

@MainActor
final class OnboardingStepOneViewModel: ObservableObject {

    private weak var onboardRouter: (any Router<OnboardingRoute>)?
    private weak var homeRouter: (any Router<HomeRoute>)?

    init(onboardRouter: (any Router<OnboardingRoute>)? = nil,
         homeRouter: (any Router<HomeRoute>)? = nil) {
        self.onboardRouter = onboardRouter
        self.homeRouter = homeRouter
    }

    func routeToNextScreen() {
        onboardRouter?.trigger(.home)
        homeRouter?.trigger(.dismissIntro)
    }
}

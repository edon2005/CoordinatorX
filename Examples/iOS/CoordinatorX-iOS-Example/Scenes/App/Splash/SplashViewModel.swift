//
//  SplashViewModel.swift
//  CoordinatorX-Example
//
//  Created by Yevhen Don on 11/12/2024.
//

import CoordinatorX
import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
    private weak var router: (any Router<AppRoute>)?

    @Published
    var timerFired = false

    init(router: (any Router<AppRoute>)?) {
        self.router = router
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.timerFired = true
            }
        }
    }

    func routeToOnboard() {
        router?.trigger(.onboarding)
    }
}

//
//  HomeMainViewModel.swift
//  CoordinatorX-iOS-Example
//
//  Created by Yevhen Don on 17/12/2024.
//

import CoordinatorX
import Foundation

@MainActor
final class HomeMainViewModel: ObservableObject {

    private weak var router: (any Router<HomeRoute>)?

    init(router: (any Router<HomeRoute>)?) {
        self.router = router
    }

    func routeToFullscreen() {
        router?.trigger(.introAsFullscreen)
    }

    func routeToOverlay() {
        router?.trigger(.introAsOverlay)
    }

    func routeToSheet() {
        router?.trigger(.introAsSheet)
    }
}

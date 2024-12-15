//
//  HomeCoordinator.swift
//  CoordinatorX-Example
//
//  Created by Yevhen Don on 11/11/2024.
//

import CoordinatorX
import SwiftUI

final class HomeCoordinator: ViewCoordinator {

    var initialRoute: HomeRoute

    init(initialRoute: HomeRoute) {
        self.initialRoute = initialRoute
    }

    @MainActor
    func prepareTransition(for route: HomeRoute) -> ViewTransition {
        switch route {
        case .dismissIntro: .dismiss
        case .main: .root
        case .introAsFullscreen: .fullScreen(.background(.black))
        case .introAsOverlay: .overlay(.background(.black))
        case .introAsSheet: .sheet(.background(.black)) // we use here and above option .background(.black) because fading with transparent background for light mode is using white color. So to achieve more solid effect we use that. Though if we are happy with default behaviour we can use just .sheet or .overlay
        case .stepOne: .set // We use here set, because it will be changed inside one of context: sheet/fullscreen/overlay. If we would use .root, then it would change view which is presented be .main
        }
    }

    @MainActor
    @ViewBuilder
    func prepareView(for route: HomeRoute, router: any Router<HomeRoute>) -> some View {
        switch route {
        case .main:
            lazy var viewModel = HomeMainViewModel(router: router)
            HomeMainView(viewModel: viewModel)

        case .introAsFullscreen:
            lazy var viewModel = OnboardingIntroViewModel(homeRouter: router)
            OnboardingIntroView(viewModel: viewModel)
                .transition(.asymmetric(insertion: .opacity, removal: .push(from: .trailing)))

        case .introAsOverlay:
            lazy var viewModel = OnboardingIntroViewModel(homeRouter: router)
            OnboardingIntroView(viewModel: viewModel)
                .transition(.asymmetric(insertion: .opacity, removal: .push(from: .trailing)))

        case .introAsSheet:
            lazy var viewModel = OnboardingIntroViewModel(homeRouter: router)
            OnboardingIntroView(viewModel: viewModel)
                .transition(.asymmetric(insertion: .opacity, removal: .push(from: .trailing)))

        case .stepOne:
            lazy var viewModel = OnboardingStepOneViewModel(homeRouter: router)
            OnboardingStepOneView(viewModel: viewModel)
                .transition(.push(from: .trailing))

        default: EmptyView()
        }
    }
}

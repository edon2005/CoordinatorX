//
//  TransitionContext + Route.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

extension TransitionContext {
    func setFullScreenRoute(_ route: RouteType) {
        let onDeinit: () -> Void = {
            Task {
                self.fullScreenRoute = route
            }
        }

        if sheetRoute != nil {
            nextTransitionContext?.onDeinit = onDeinit
            fullScreenRoute = nil
        } else if self.fullScreenRoute != nil  {
            nextTransitionContext?.onDeinit = onDeinit
            self.fullScreenRoute = nil
        } else {
            self.fullScreenRoute = route
        }
    }

    func setOverlayRoute(_ route: RouteType) {
        overlayRoute = route
    }

    func setRootRoute(_ route: RouteType) {
        getRootContext()?.rootRoute = route
    }

    func setRoute(_ route: RouteType) {
        self.rootRoute = route
    }

    func setSheetRoute(_ route: RouteType) {
        let onDeinit: () -> Void = {
            Task {
                self.sheetRoute = route
            }
        }

        if fullScreenRoute != nil {
            nextTransitionContext?.onDeinit = onDeinit
            fullScreenRoute = nil
        } else if self.sheetRoute != nil  {
            nextTransitionContext?.onDeinit = onDeinit
            self.sheetRoute = nil
        } else {
            self.sheetRoute = route
        }
    }
}

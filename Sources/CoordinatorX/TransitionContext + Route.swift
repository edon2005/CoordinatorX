//
//  TransitionContext + Route.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 11/11/2024.
//

import SwiftUI

extension TransitionContext {

    func getRootContext() -> Self? {
        self.prevTransitionContext == nil ? self : prevTransitionContext?.getRootContext()
    }

#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    func setFullScreenRoute(_ route: RouteType, options: [TransitionOptions]) {
        let model = prepareTransitionModel(route: route, options: options)
        let onDeinit: () -> Void = {
            Task {
                self.fullScreenRoute = model
            }
        }

        if sheetRoute != nil {
            nextTransitionContext?.onDeinit = onDeinit
            fullScreenRoute = nil
        } else if self.fullScreenRoute != nil  {
            nextTransitionContext?.onDeinit = onDeinit
            self.fullScreenRoute = nil
        } else {
            self.fullScreenRoute = model
        }
    }
#endif

    func setOverlayRoute(_ route: RouteType, options: [TransitionOptions]) {
        let model = prepareTransitionModel(route: route, options: options)
        overlayRoute = model
    }

    func setRootRoute(_ route: RouteType) {
        getRootContext()?.rootRoute = route
    }

    func setRoute(_ route: RouteType) {
        self.rootRoute = route
    }

    func setSheetRoute(_ route: RouteType, options: [TransitionOptions]) {
        let model = prepareTransitionModel(route: route, options: options)
        let onDeinit: () -> Void = {
            Task {
                self.sheetRoute = model
            }
        }

#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        if fullScreenRoute != nil {
            nextTransitionContext?.onDeinit = onDeinit
            fullScreenRoute = nil
        } else if self.sheetRoute != nil  {
            nextTransitionContext?.onDeinit = onDeinit
            self.sheetRoute = nil
        } else {
            self.sheetRoute = model
        }
#else
        if self.sheetRoute != nil  {
            nextTransitionContext?.onDeinit = onDeinit
            self.sheetRoute = nil
        } else {
            self.sheetRoute = model
        }
#endif
    }

    func prepareTransitionModel(route: RouteType, options: [TransitionOptions]) -> Transition<RouteType> {
        var backgroundColor: Color = .clear
        var style: AnyTransition = .opacity
        options.forEach {
            switch $0 {
            case .background(let color): backgroundColor = color
            case .transition(let transition): style = transition
            }
        }
        return .init(route: route, backgroundColor: backgroundColor, style: style)
    }
}

//
//  TransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import Foundation

protocol TransitionContext: ObservableObject, Router where RouteType == CoordinatorType.RouteType {

    associatedtype CoordinatorType: Coordinator

    var rootRoute: RouteType { get set }
#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    var fullScreenRoute: Transition<RouteType>? { get set }
#endif
    var overlayRoute: Transition<RouteType>? { get set }
    var sheetRoute: Transition<RouteType>? { get set }
    var prevTransitionContext: Self? { get }
    var nextTransitionContext: Self? { get }

    var onDeinit: (() -> Void)? { get set }

    init(rootRoute: RouteType, delegate: CoordinatorType?, prevTransitionContext: Self?)
    func getRootContext() -> Self?
}

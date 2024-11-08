//
//  TransitionContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import Foundation

protocol TransitionContext: ObservableObject, Router where RouteType == CoordinatorType.RouteType {

    associatedtype CoordinatorType: Coordinator
//    associatedtype TransitionContextType: TransitionContext

    var rootRoute: RouteType { get set }
    var fullScreenRoute: RouteType? { get set }
    var overlayRoute: RouteType? { get set }
    var sheetRoute: RouteType? { get set }
    var prevTransitionContext: Self? { get }
    var nextTransitionContext: Self? { get }

    init(rootRoute: RouteType, delegate: CoordinatorType?, isRoot: Bool, prevTransitionContext: Self?)
}

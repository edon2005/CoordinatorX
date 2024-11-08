//
//  MainContext.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import SwiftUI

public protocol MainContext: View where CoordinatorType.RouteType == RouteType {

    associatedtype CoordinatorType: Coordinator
    associatedtype RouteType: Route

    var coordinator: CoordinatorType { get set }

    init(coordinator: CoordinatorType)

}

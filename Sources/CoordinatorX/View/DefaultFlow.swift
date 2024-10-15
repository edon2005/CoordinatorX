//
//  DefaultFlow.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 15/10/2024.
//

import SwiftUI

public protocol DefaultViewFlow: View {
    associatedtype CoordinatorType: Coordinator

    var coordinator: CoordinatorType { get set }

    init(coordinator: CoordinatorType)
}

public extension DefaultViewFlow where CoordinatorType.TransitionType == ViewTransitionType {
    var body: some View {
        MainViewContext(coordinator: coordinator)
    }
}

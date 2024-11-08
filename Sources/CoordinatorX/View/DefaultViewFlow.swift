//
//  DefaultViewFlow.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import SwiftUI

public protocol DefaultViewFlow: DefaultFlow where CoordinatorType: ViewCoordinator {}

extension DefaultViewFlow {
    var body: some View {
        MainViewContext(coordinator: coordinator)
    }
}

//
//  DefaultRedirectFlow.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import SwiftUI

public protocol DefaultRedirectFlow: DefaultFlow where CoordinatorType: RedirectionCoordinator {}

public extension DefaultRedirectFlow {
    var body: some View {
        MainRedirectionViewContext(coordinator: coordinator)
    }
}

//
//  DefaultFlow.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import SwiftUI

public protocol DefaultFlow: View {
    associatedtype CoordinatorType: Coordinator

    var coordinator: CoordinatorType { get set }

    init(coordinator: CoordinatorType)
}

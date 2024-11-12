//
//  ViewCoordinator.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import Foundation

public protocol ViewCoordinator: Coordinator where TransitionType == ViewTransition {}

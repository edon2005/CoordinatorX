//
//  Context.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/11/2024.
//

import SwiftUI

public protocol Context: View {

    associatedtype RouteType: Route
    associatedtype CoordinatorType: Coordinator

}

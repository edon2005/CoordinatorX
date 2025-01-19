//
//  StatusBarViewController.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 18/01/2025.
//

import SwiftUI

extension View {
    public func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        self.background(StatusBarStyleModifier(style: style))
    }
}

struct StatusBarStyleModifier: UIViewControllerRepresentable {
    var style: UIStatusBarStyle

    func makeUIViewController(context: Self.Context) -> StatusBarViewController {
        let viewController = StatusBarViewController()
        viewController.view.backgroundColor = .clear
        viewController.modalPresentationCapturesStatusBarAppearance = true
        return viewController
    }

    func updateUIViewController(_ uiViewController: StatusBarViewController, context: Self.Context) {
        uiViewController.statusBarStyle = style
    }
}

final class StatusBarViewController: UIViewController {

    var statusBarStyle: UIStatusBarStyle = .default

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }
}

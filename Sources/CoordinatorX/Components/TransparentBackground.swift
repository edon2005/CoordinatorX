//
//  TransparentBackground.swift
//  CoordinatorX
//
//  Created by Yevhen Don on 08/01/2025.
//

import SwiftUI

public struct TransparentBackground: UIViewRepresentable {
    public init() {}

    public func makeUIView(context: Self.Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Self.Context) { }
}

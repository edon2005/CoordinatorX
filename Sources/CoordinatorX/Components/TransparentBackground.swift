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
        let view = TransparentView()
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Self.Context) { }
}

final class TransparentView: UIView {
    override func layoutSubviews() {
        superview?.superview?.backgroundColor = .clear
        super.layoutSubviews()
    }
}

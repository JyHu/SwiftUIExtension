//
//  ViewExtension.swift
//  SwiftUIForMac
//
//  Created by Jo on 2022/7/24.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func disableAutoAdjustment() -> some View {
        #if !os(macOS)
        self
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .keyboardType(.asciiCapable)
        #else
        self
        #endif
    }
    
    func makeCapsuleBackground(_ color: Color = .red) -> some View {
        self.padding().background(Capsule().foregroundColor(color))
    }
    
    func returnMutableSelf(_ body: (inout Self) -> Void) -> Self {
        var selfCopy = self
        body(&selfCopy)
        return selfCopy
    }
    
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func addBorder<S>(_ content: S, width: Double = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
    }
    
#if !os(macOS)
    @ViewBuilder
    func hideTabBar() -> some View {
        if #available(iOS 18.0, *) {
            self.toolbarVisibility(.hidden, for: .tabBar)
        } else if #available(iOS 16.0, *) {
            self.toolbar(.hidden, for: .tabBar)
        } else {
            self
        }
    }
#endif
}

public extension View {
    
    /// Applies multiline text formatting to the view conditionally.
    ///
    /// This modifier is useful for customizing how text behaves when it spans multiple lines,
    /// including line limit, alignment, and sizing behavior.
    ///
    /// - Parameters:
    ///   - multilines: A Boolean value that determines whether the view should be styled for multiline text.
    ///     If `false`, no formatting is applied and the original view is returned.
    ///   - lineLimit: The maximum number of lines to display. If set to `0`, it is treated as unlimited (`nil`).
    ///   - textAlignment: The alignment of the text when multiline is enabled. Defaults to `.leading`.
    ///
    /// - Returns: A view modified with multiline styling if `multilines` is `true`; otherwise, the original view.
    @ViewBuilder
    func multilinesTextStyle(_ multilines: Bool = true, lineLimit: Int? = nil, textAlignment: TextAlignment = .leading) -> some View {
        if multilines {
            self.lineLimit(lineLimit == 0 ? nil : lineLimit)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            self
        }
    }
}

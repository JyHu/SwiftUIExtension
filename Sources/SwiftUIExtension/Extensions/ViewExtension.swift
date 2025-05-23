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
    
    /// 给视图添加一个边框
    ///
    /// Text("Hello World").addBorder(Color.blue, width: 3, cornerRadius: 5)
    ///
    /// - Parameters:
    ///   - content: <#content description#>
    ///   - width: <#width description#>
    ///   - cornerRadius: <#cornerRadius description#>
    /// - Returns: <#description#>
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
    /// 调整支持多行展示
    func multilinesStyle() -> some View {
        self.lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }
}

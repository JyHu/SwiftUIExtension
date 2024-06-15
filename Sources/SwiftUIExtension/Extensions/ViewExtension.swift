//
//  ViewExtension.swift
//  SwiftUIForMac
//
//  Created by Jo on 2022/7/24.
//

import SwiftUI

public extension View {
    var randomBackground: some View {
        background(Color.random)
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
}

public extension View {
    /// 调整支持多行展示
    func multilinesStyle() -> some View {
        self.lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }
}

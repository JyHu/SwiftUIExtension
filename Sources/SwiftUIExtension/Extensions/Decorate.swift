//
//  SwiftUIView.swift
//  
//
//  Created by hujinyou on 2024/5/10.
//

import SwiftUI

public extension View {
    
    /// 在使用一下版本不兼容的api的时候，可以方便的处理而不用单独封装组件或者方法，如：
    ///   ```
    ///   Text("Hello")
    ///       .inlineModifier {
    ///           if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
    ///               $0.foregroundStyle(.red)
    ///           } else {
    ///               $0.foregroundColor(.red)
    ///           }
    ///       }
    ///   ```
    ///
    /// 在比如，在不同的状态下对view使用不同的修饰符，也可以很方便的实现，如：
    ///   ```
    ///   @State var isHighlighted: Bool = false
    ///
    ///   Text("Hello")
    ///       .inlineModifier {
    ///           if isHighlighted {
    ///               $0.foregroundStyle(.red)
    ///                   .fontWeight(.bold)
    ///                   .backgroundStyle(.white)
    ///                   .background(in: RoundedRectangle(cornerRadius: 5))
    ///           } else {
    ///               $0.foregroundStyle(.gray)
    ///                   .strikethrough()
    ///           }
    ///       }
    ///   ```
    @ViewBuilder
    func inlineModifier(@ViewBuilder transform: (Self) -> some View) -> some View {
        transform(self)
    }
}

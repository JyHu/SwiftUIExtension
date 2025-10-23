//
//  SizeBindingModifier.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/10/12.
//

import SwiftUI

// MARK: - 通用 Modifier
private struct SizeBindingModifier: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { newValue in
                if size != newValue {
                    size = newValue
                }
            }
    }
}

// MARK: - PreferenceKey
private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - View 扩展
public extension View {
    /// 绑定当前视图的尺寸到一个 Binding<CGSize>
    func bindSize(to binding: Binding<CGSize>) -> some View {
        self.modifier(SizeBindingModifier(size: binding))
    }
}

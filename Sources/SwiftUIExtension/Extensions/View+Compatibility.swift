//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/13.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension View {
    @ViewBuilder
    func adp_onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View where V: Equatable {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            self.onChange(of: value) { oldValue, newValue in
                action(newValue)
            }
        } else {
            self.onChange(of: value, perform: action)
        }
    }
    
    @ViewBuilder
    func adp_onChange<V>(of value: V, initial: Bool = false, _ action: @escaping () -> Void) -> some View where V: Equatable {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            self.onChange(of: value, initial: initial, action)
        } else {
            self.onChange(of: value) { _ in
                action()
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    @ViewBuilder
    func adp_foregroundColor(_ color: Color) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            self.foregroundStyle(color)
        } else {
            self.foregroundColor(color)
        }
    }
}

@available(macCatalyst 14.0, macOS 11.0, *)
public extension View {
    @ViewBuilder
    func adp_navigationSubtitle(_ subTitle: Text) -> some View {
        #if os(macOS)
        self.navigationSubtitle(subTitle)
        #else
        self
        #endif
    }
    
    @ViewBuilder
    func adp_navigationSubtitle(_ subTitle: String) -> some View {
        #if os(macOS)
        self.navigationSubtitle(subTitle)
        #else
        self
        #endif
    }
}

public extension View {
    /// 适配高版本中的按键事件
    /// action 返回 true 表示已经处理了按键事件；返回 false 表示未处理，需要由系统处理
    func adp_onKeyPress(_ key: KeyEquivalent, action: @escaping () -> Bool) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, *) {
            return self.onKeyPress(key) {
                action() ? .handled : .ignored
            }
        }
        return self
    }
}

public extension View {
    @ViewBuilder
    func adp_overlay<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            self.overlay(alignment: alignment, content: content)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func adp_overlay<S>(_ style: S, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View where S : ShapeStyle {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            self.overlay(style, ignoresSafeAreaEdges: edges)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func adp_overlay<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : Shape {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            self.overlay(style, in: shape, fillStyle: fillStyle)
        } else {
            self
        }
    }
}

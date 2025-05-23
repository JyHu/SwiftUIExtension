//
//  View+Debug.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/4/15.
//

import SwiftUI

#if DEBUG
private struct DebugRandomBackgroundKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
#endif

public extension EnvironmentValues {
    /// 是否开启随机背景色功能
    /// 只在debug模式下生效，在release环境下该设置不会生效
    var debugRandomBackground: Bool {
        get {
#if DEBUG
            self[DebugRandomBackgroundKey.self]
#else
            false
#endif
        }
        set {
#if DEBUG
            self[DebugRandomBackgroundKey.self] = newValue
#endif
        }
    }
}

public extension View {
    var randomBackground: some View {
        self.background(Color.random)
    }
    
    /// 设置随机的背景色，受 debugRandomBackground 环境变量控制，全局设置的时候可以如下操作控制：
    /// aview.environment(\.debugRandomBackground, false)
    ///
    /// 只在debug模式下生效，在release环境下该设置不会生效
    var debugRandomBackground: some View {
#if DEBUG
        modifier(RandomBackgroundModifier())
#else
        self
#endif
    }
    
    var showGeometry: some View {
#if DEBUG
        modifier(ShowGeometryModifier())
//        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
//            return GeometryReader { proxy in
//                self.overlay(alignment: .bottomTrailing) {
//                        Text("size: \(proxy.size.debugDescription)")
//                            .padding(4)
//                            .background(Color.red.opacity(0.2))
//                    }
//            }
//        } else {
//            return self
//        }
#else
        self
#endif
    }
}

public struct RandomBackgroundModifier: ViewModifier {
#if DEBUG
    @Environment(\.debugRandomBackground) var debugRandomBackground: Bool
#endif
    
    public func body(content: Content) -> some View {
#if DEBUG
        if debugRandomBackground {
            content.background(Color.random.opacity(0.2))
        } else {
            content
        }
#else
        content
#endif
    }
}

public struct ShowGeometryModifier: ViewModifier {
    @State private var isHovering: Bool = false
    
    public func body(content: Content) -> some View {
#if DEBUG
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            GeometryReader { proxy in
                content
                    .overlay(alignment: .bottomTrailing) {
                        Text("size: \(proxy.size.debugDescription)")
                            .padding(4)
                            .background(Color.red.opacity(isHovering ? 1 : 0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onHover {
                                isHovering = $0
                            }
                    }
            }
        } else {
            content
        }
#else
        content
#endif
    }
}

//
//  File.swift
//
//
//  Created by hujinyou on 2024/9/9.
//

import SwiftUI

#if !os(macOS)

public extension UserInterfaceSizeClass {
    var debugName: String {
        switch self {
        case .compact:      "Com"
        case .regular:      "Reg"
        @unknown default:   "Un"
        }
    }
}

/// 判断当前布局是否应为 Compact
public func isCompactLayout(horizontal: UserInterfaceSizeClass?, vertical: UserInterfaceSizeClass?) -> Bool {    
    /// iPhone
    /// 竖屏 isCompactLayout: horizontal = Com, vertical = Reg
    /// 横屏 isCompactLayout: horizontal = Com, vertical = Com
    
    return vertical == .compact || horizontal == nil
}


public struct SizeClassView<Content: View>: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ViewBuilder private var viewMaker: (_ isCompact: Bool) -> Content
    
    public init(@ViewBuilder viewMaker: @escaping (_ isCompact: Bool) -> Content) {
        self.viewMaker = viewMaker
    }
    
    public var body: some View {
        viewMaker(isCompactLayout(horizontal: horizontalSizeClass, vertical: verticalSizeClass))
    }
}

#endif

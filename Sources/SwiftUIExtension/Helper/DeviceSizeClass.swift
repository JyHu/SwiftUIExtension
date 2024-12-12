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

public func isCompact(hori horizontalSizeClass: UserInterfaceSizeClass?, vert verticalSizeClass: UserInterfaceSizeClass?) -> Bool {
    /// iphone 默认都当作小屏处理，不管横屏状态
    if Platform.current == .iphone {
        return true
    }
    
    return (Platform.current == .iphone && verticalSizeClass == .regular) ||
        (Platform.current == .ipad && horizontalSizeClass == .compact)
}


public struct SizeClassView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private let viewMaker: (_ isCompact: Bool) -> AnyView
    
    public init(@ViewBuilder viewMaker: @escaping (_ isCompact: Bool) -> some View) {
        self.viewMaker = { isComact in
            viewMaker(isComact).eraseToAnyView()
        }
    }
    
    public var body: some View {
        viewMaker(isCompact(hori: horizontalSizeClass, vert: verticalSizeClass))
    }
}

#endif

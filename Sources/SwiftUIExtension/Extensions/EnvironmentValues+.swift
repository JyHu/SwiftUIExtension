//
//  File.swift
//  
//
//  Created by hujinyou on 2024/5/8.
//

import Foundation
import SwiftUI

public enum DeviceOrientation {
    /// 竖屏
    case portrait
    /// 横屏
    case landscape
}

public extension EnvironmentValues {
    /// @Environment(\.deviceOrientation) var deviceOrientation
    var deviceOrientation: DeviceOrientation {
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            return .landscape
        } else {
            return .portrait
        }
    }
}

public struct DeviceOrientationView<T>: View where T: View {
    private let content: (DeviceOrientation) -> T
    @Environment(\.deviceOrientation) var deviceOrientation
    
    public init(@ViewBuilder content: @escaping (DeviceOrientation) -> T) {
        self.content = content
    }
    
    public var body: some View {
        content(deviceOrientation)
    }
}

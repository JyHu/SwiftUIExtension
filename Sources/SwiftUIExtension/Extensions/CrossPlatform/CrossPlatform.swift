//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2023/12/12.
//

import SwiftUI

public enum Platform {
    case iphone
    case ipad
    case mac
    case vision
    case tv
    case carPlay
    case unknown
    
    public static var current: Platform {
#if os(macOS)
        return .mac
#else
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        return .iphone
        case .pad:          return .ipad
        case .tv:           return .tv
        case .carPlay:      return .carPlay
        case .mac:          return .mac
        case .vision:       return .vision
        case .unspecified:  return .unknown
        @unknown default: return .unknown
        }
#endif
    }
}

public struct PlatformView<T>: View where T: View {
    private let priContent: (Platform) -> T
    
    public init(@ViewBuilder content: @escaping (Platform) -> T) {
        self.priContent = content
    }
    
    public var body: some View {
        priContent(.current)
    }
}

//
//  Scene+Compatibility.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/5/11.
//

import SwiftUI

public enum SceneRestorationWrapperBehavior {
    case automatic
    case disabled

#if os(macOS)
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    var nativeValue: SceneRestorationBehavior {
        switch self {
        case .automatic: return .automatic
        case .disabled: return .disabled
        }
    }
#endif
}

public extension Scene {
    func adp_restorationBehavior(_ behavior: SceneRestorationWrapperBehavior) -> some Scene {
#if os(macOS)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            return self.restorationBehavior(behavior.nativeValue)
        } else {
            return self
        }
#else
        self
#endif
    }
}

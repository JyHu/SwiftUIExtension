//
//  Scene+.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/11/13.
//

import SwiftUI

public extension Scene {
    func disableRestorationBehavior() -> some Scene {
        if #available(macOS 15.0, *) {
            return self.restorationBehavior(.disabled)
        } else {
            return self
        }
    }
}

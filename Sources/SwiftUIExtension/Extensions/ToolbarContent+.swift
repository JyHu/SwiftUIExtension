//
//  ToolbarContent+.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2026/8/31.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
public extension ToolbarContent {
    @ToolbarContentBuilder
    func hideSharedBackground() -> some ToolbarContent {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}

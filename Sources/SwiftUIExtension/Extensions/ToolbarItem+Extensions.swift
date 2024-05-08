//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/13.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension ToolbarItem {
    init(placement: ToolbarItemPlacement, other: ToolbarItemPlacement, @ViewBuilder content: () -> Content) where ID == () {
        self.init(placement: Platform.current == .iphone ? placement : other, content: content)
    }
    
    init(id: String, placement: ToolbarItemPlacement = .automatic, other: ToolbarItemPlacement, @ViewBuilder content: () -> Content) where ID == String {
        self.init(id: id, placement: Platform.current == .iphone ? placement : other, content: content)
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension ToolbarItemGroup {
    init(placement: ToolbarItemPlacement, other: ToolbarItemPlacement, @ViewBuilder content: () -> Content) {
        self.init(placement: Platform.current == .iphone ? placement : other, content: content)
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public extension ToolbarItemGroup {
    init<C, L>(placement: ToolbarItemPlacement, other: ToolbarItemPlacement, @ViewBuilder content: () -> C, @ViewBuilder label: () -> L) where Content == LabeledToolbarItemGroupContent<C, L>, C : View, L : View {
        self.init(placement: Platform.current == .iphone ? placement : other, content: content, label: label)
    }
}

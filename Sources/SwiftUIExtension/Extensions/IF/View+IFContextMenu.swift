//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/18.
//

import SwiftUI

public extension View {
    @available(iOS 13.0, macOS 10.15, tvOS 14.0, *)
    @ViewBuilder func contextMenu<MenuItems>(if condition: Bool, @ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
        self.if(condition) {
            $0.contextMenu(menuItems: menuItems)
        }
    }
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
    @ViewBuilder func contextMenu<M, P>(if condition: Bool, @ViewBuilder menuItems: () -> M, @ViewBuilder preview: () -> P) -> some View where M : View, P : View {
        self.if(condition) {
            $0.contextMenu(menuItems: menuItems, preview: preview)
        }
    }
    
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @ViewBuilder func contextMenu<I, M>(if condition: Bool, forSelectionType itemType: I.Type = I.self, @ViewBuilder menu: @escaping (Set<I>) -> M, primaryAction: ((Set<I>) -> Void)? = nil) -> some View where I : Hashable, M : View {
        self.if(condition) {
            $0.contextMenu(forSelectionType: itemType, menu: menu, primaryAction: primaryAction)
        }
    }
}


public extension View {
    @available(iOS 13.0, macOS 10.15, tvOS 14.0, *)
    @ViewBuilder func contextMenu<MenuItems, D>(if data: D?, default defaultValue: D? = nil, @ViewBuilder menuItems: (D) -> MenuItems) -> some View where MenuItems : View {
        self.if(data, default: defaultValue) { transformSelf, data in
            transformSelf.contextMenu {
                menuItems(data)
            }
        }
    }
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
    @ViewBuilder func contextMenu<M, P, D>(if data: D?, default defaultValue: D? = nil, @ViewBuilder menuItems: (D) -> M, @ViewBuilder preview: (D) -> P) -> some View where M : View, P : View {
        self.if(data, default: defaultValue) { transformSelf, data in
            transformSelf.contextMenu {
                menuItems(data)
            } preview: {
                preview(data)
            }
        }
    }
    
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @ViewBuilder func contextMenu<I, M, D>(if data: D?, default defaultValue: D? = nil, forSelectionType itemType: I.Type = I.self, @ViewBuilder menu: @escaping (Set<I>, D) -> M, primaryAction: ((Set<I>, D) -> Void)? = nil) -> some View where I : Hashable, M : View {
        self.if(data, default: defaultValue) { transformSelf, data in
            transformSelf.contextMenu(forSelectionType: itemType) { items in
                menu(items, data)
            } primaryAction: { items in
                primaryAction?(items, data)
            }
        }
    }
}

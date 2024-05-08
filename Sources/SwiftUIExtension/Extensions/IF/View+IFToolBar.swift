//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/18.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension View {
    func toolbar<Content>(if condition: Bool, @ToolbarContentBuilder contentBuilder: () -> Content) -> some View where Content: View {
        self.if(condition) {
            $0.toolbar(content: contentBuilder)
        }
    }
    

    func toolbar<Content>(if condition: Bool, @ToolbarContentBuilder contentBuilder: () -> Content) -> some View where Content: ToolbarContent {
        self.if(condition) {
            $0.toolbar(content: contentBuilder)
        }
    }
    

    func toolbar<Content>(if condition: Bool, id: String, @ToolbarContentBuilder contentBuilder: () -> Content) -> some View where Content: CustomizableToolbarContent {
        self.if(condition) {
            $0.toolbar(id: id, content: contentBuilder)
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension View {
    func toolbar<Content, D>(if data: D?, default defaultValue: D? = nil, @ToolbarContentBuilder contentBuilder: (D) -> Content) -> some View where Content: View {
        self.if(data, default: defaultValue) { transformSelf, data in
            transformSelf.toolbar {
                contentBuilder(data)
            }
        }
    }
    
    func toolbar<Content, D>(if data: D?, default defaultValue: D? = nil, @ToolbarContentBuilder contentBuilder: (D) -> Content) -> some View where Content: ToolbarContent {
        self.if(data, default: defaultValue) { transformSelf, data in
            transformSelf.toolbar {
                contentBuilder(data)
            }
        }
    }
    
    func toolbar<Content, D>(if data: D?, default defaultValue: D? = nil, id: String, @ToolbarContentBuilder contentBuilder: (D) -> Content) -> some View where Content: CustomizableToolbarContent {
        self.if(data, default: defaultValue) { transformSelf, data in
            transformSelf.toolbar(id: id) {
                contentBuilder(data)
            }
        }
    }
}

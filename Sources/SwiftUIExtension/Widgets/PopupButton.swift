//
//  PopupButton.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2026/2/17.
//

import SwiftUI

public struct PopupButton<L, P>: View where L: View, P: View {
    @State private var isPresented: Bool = false
    
    public let label: () -> L
    public let content: () -> P
    
    public init(@ViewBuilder label: @escaping () -> L, @ViewBuilder content: @escaping () -> P) {
        self.label = label
        self.content = content
    }
    
    public var body: some View {
        Button {
            isPresented = true
        } label: {
            label()
        }
        .buttonStyle(.borderless)
        .popover(isPresented: $isPresented) {
            content()
                .padding(.all, 20)
        }
    }
}

public extension PopupButton where L == Text {
    init(label: String, @ViewBuilder content: @escaping () -> P) {
        self.init(label: { Text(label) }, content: content)
    }
    
    init(label: LocalizedStringKey, @ViewBuilder content: @escaping () -> P) {
        self.init(label: { Text(label) }, content: content)
    }
    
    @available(iOS 15.0, macOS 12.0, *)
    init(label: AttributedString, @ViewBuilder content: @escaping () -> P) {
        self.init(label: { Text(label) }, content: content)
    }
}

public extension PopupButton where L == Image {
    init(image: String, @ViewBuilder content: @escaping () -> P) {
        self.init(label: { Image(image) }, content: content)
    }
    
    init(systemName: String, @ViewBuilder content: @escaping () -> P) {
        self.init(label: { Image(systemName: systemName) }, content: content)
    }
}

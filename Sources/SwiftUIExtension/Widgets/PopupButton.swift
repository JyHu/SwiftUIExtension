//
//  PopupButton.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2026/2/17.
//

import SwiftUI

public struct PopupButton<L, P>: View where L: View, P: View {
    let arrowEdge: Edge?
    @State private var isPresented: Bool = false
    
    @ViewBuilder public let label: () -> L
    @ViewBuilder public let content: () -> P
    
    public init(arrowEdge: Edge? = nil, @ViewBuilder label: @escaping () -> L, @ViewBuilder content: @escaping () -> P) {
        self.arrowEdge = arrowEdge
        self.label = label
        self.content = content
    }
    
    public var body: some View {
        Button {
            isPresented = true
        } label: {
            label()
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isPresented, arrowEdge: arrowEdge) {
            content()
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

#Preview {
    VStack {
        PopupButton(label: "hello") {
            VStack {
                Text("hello")
            }
            .padding()
        }
    }
    .padding(50)
}

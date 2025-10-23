//
//  Toggle+.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/7/21.
//

import SwiftUI

public struct AnimatedToggle<L: View>: View {
    @Binding var isOn: Bool
    @ViewBuilder var label: () -> L
    
    public init(isOn: Binding<Bool>, @ViewBuilder label: @escaping () -> L) {
        self._isOn = isOn
        self.label = label
    }
    
    public var body: some View {
        Toggle(isOn: Binding(get: {
            return self.isOn
        }, set: { isOn in
            withAnimation {
                self.isOn = isOn
            }
        }), label: label)
    }
}

public extension AnimatedToggle where L == Text {
    init(label: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(label) })
    }
    
    init(label: LocalizedStringKey, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(label) })
    }
}

public extension AnimatedToggle where L == Image {
    init(image: Image, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { image })
    }
    
    init(image: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Image(image) })
    }
    
    init(systemImage: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Image(systemName: systemImage) })
    }
}

public extension AnimatedToggle where L == EmptyView {
    init(isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { EmptyView() })
    }
}


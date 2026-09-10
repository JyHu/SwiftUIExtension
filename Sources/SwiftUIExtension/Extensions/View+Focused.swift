//
//  View+Focused.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2026/9/10.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
private struct AccessoryDoneModifier<T: View>: ViewModifier {
    let doneTitle: String
    @ViewBuilder var leadingView: () -> T
    @FocusState<Bool> private var isEditing

    init(doneTitle: String, @ViewBuilder leadingView: @escaping () -> T) {
        self.doneTitle = doneTitle
        self.leadingView = leadingView
    }
    
    func body(content: Content) -> some View {
        content
            .focused($isEditing)
            .toolbar {
                if isEditing {
                    ToolbarItemGroup(placement: .keyboard) {
                        leadingView()
                        
                        Spacer()
                        
                        Button(doneTitle) {
                            isEditing = false
                        }
                    }
                }
            }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    @ViewBuilder
    func applyFocusedControl(doneTitle: String = "Done") -> some View {
        modifier(AccessoryDoneModifier(doneTitle: doneTitle, leadingView: { }))
    }
    
    @ViewBuilder
    func applyFocusedControl(doneTitle: String = "Done", @ViewBuilder leading: @escaping () -> some View) -> some View {
        modifier(AccessoryDoneModifier(doneTitle: doneTitle, leadingView: leading))
    }
}

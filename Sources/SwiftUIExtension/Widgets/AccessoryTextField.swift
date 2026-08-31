//
//  AccessoryTextField.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2026/6/17.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
private struct _AccessoryTextField: View {
    private let prompt: String?
    private let doneTitle: String
    @Binding private var text: String
    @FocusState<Bool> private var isEditing
    
    init(prompt: String? = nil, doneTitle: String = "Done", text: Binding<String>) {
        self.prompt = prompt
        self.doneTitle = doneTitle
        _text = text
    }
    
    var body: some View {
        TextField("", text: $text, prompt: Text(prompt ?? ""))
            .focused($isEditing)
            .toolbar {
                if isEditing {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            
                            Button(doneTitle) {
                                isEditing = false
                            }
                        }
                    }
                }
            }
    }
}

public struct AccessoryTextField: View {
    private let prompt: String?
    private let doneTitle: String
    @Binding private var text: String
    
    init(prompt: String? = nil, doneTitle: String = "Done", text: Binding<String>) {
        self.prompt = prompt
        self.doneTitle = doneTitle
        _text = text
    }
    
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
            _AccessoryTextField(prompt: prompt, doneTitle: doneTitle, text: $text)
        } else {
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                TextField("", text: $text, prompt: Text(prompt ?? ""))
            } else {
                TextField("", text: $text)
            }
        }
    }
}
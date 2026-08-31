//
//  AccessoryTextEditor.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2026/6/17.
//

import SwiftUI

private struct _TextEditor: View {
    let prompt: String?
    let minHeight: Double
    @Binding var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .frame(minHeight: minHeight)
            .adp_overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(prompt ?? "")
                        .adp_foregroundStyle(.tertiaryLabel)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                        .allowsHitTesting(false)
                }
            }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
private struct _AccessoryTextEditor: View {
    private let prompt: String?
    private let minHeight: Double
    private let doneTitle: String
    @Binding private var text: String
    
    @FocusState<Bool> private var isEditing
    
    init(_ prompt: String?, minHeight: Double = 80, doneTitle: String = "Done", text: Binding<String>) {
        self.prompt = prompt
        self.minHeight = minHeight
        self.doneTitle = doneTitle
        _text = text
    }
    
    var body: some View {
        _TextEditor(prompt: prompt, minHeight: minHeight, text: $text)
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

public struct AccessoryTextEditor: View {
    private let prompt: String?
    private let minHeight: Double
    private let doneTitle: String
    @Binding private var text: String
    
    init(prompt: String? = nil, minHeight: Double = 80, doneTitle: String = "Done", text: Binding<String>) {
        self.prompt = prompt
        self.minHeight = minHeight
        self.doneTitle = doneTitle
        _text = text
    }
    
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
            _AccessoryTextEditor(prompt, minHeight: minHeight, doneTitle: doneTitle, text: $text)
        } else {
            _TextEditor(prompt: prompt, minHeight: minHeight, text: $text)
        }
    }
}
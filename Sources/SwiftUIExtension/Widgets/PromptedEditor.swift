//
//  PromptedEditor.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/2/6.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
public struct PromptedEditor: View {
    private let prompt: String
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    @Environment(\.font) private var font

    public init(text: Binding<String>, prompt: String) {
        self._text = text
        self.prompt = prompt
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .focused($isFocused)
                .font(font)
                .scrollContentBackground(.hidden) // iOS 16+ / macOS 13+
                .debugRandomBackground
            
            if text.isEmpty {
                Text(prompt)
                    .font(font)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .allowsHitTesting(false) // 确保点击穿透
                    .debugRandomBackground
            }
        }
        .onTapGesture {
            if text.isEmpty {
                isFocused = true
            }
        }
#if !os(macOS)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                if isFocused {
                    HStack {
                        Spacer()
                        Button("Done") {
                            isFocused = false
                        }
                    }
                }
            }
        }
#endif
    }
}

#if DEBUG
struct PromptedEditor_Previews: PreviewProvider {
    static var previews: some View {
        PromptedEditorPreview()
            .previewDisplayName("PromptedEditor Preview")
    }
    
    private struct PromptedEditorPreview: View {
        @State var text: String = ""
        var body: some View {
            if #available(iOS 16.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                PromptedEditor(text: $text, prompt: "请输入内容")
            }
                
        }
    }
}
#endif

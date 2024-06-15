//
//  SwiftUIView.swift
//
//
//  Created by hujinyou on 2024/5/27.
//

import SwiftUI

public struct EnumPicker<Content>: View where Content: DisplayLabelProtocol {
    
    @Binding private var selection: Content
    
    private let title: String?
    private let contents: [Content]
    
    public init(_ title: String? = nil, selection: Binding<Content>) {
        _selection = selection
        self.title = title
        self.contents = Array(Content.allCases)
    }
    
    public var body: some View {
        Picker(title ?? "", selection: $selection) {
            ForEach(contents) { content in
                content
                    .makeDisplayLabel()
                    .tag(content)
            }
        }
        .labelsHidden(if: title == nil)
    }
}

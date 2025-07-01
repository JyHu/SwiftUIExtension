//
//  DisplayedText.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/6/29.
//

import SwiftUI

public enum DisplayedText {
    case text(_ text: String, comment: String? = nil)
    case localized(_ key: LocalizedStringKey, comment: String? = nil)
}

public extension Text {
    init(_ displayedText: DisplayedText) {
        switch displayedText {
        case .text(let text, _):     self.init(text)
        case .localized(let key, _): self.init(key)
        }
    }
}

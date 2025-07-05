//
//  DisplayedText.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/6/29.
//

import SwiftUI

/// A unified abstraction to represent either a plain string or a localized string key,
/// for use with SwiftUI's `Text` views.
///
/// This is useful when you want to support both raw strings (e.g. dynamic content)
/// and localization keys (e.g. from `.strings` files) in a single, type-safe enum.
public enum DisplayedText {
    
    /// A plain string to display directly, without localization.
    ///
    /// - Parameters:
    ///   - text: The raw text to be displayed.
    ///   - comment: An optional developer-facing comment. Ignored at runtime,
    ///     but may be useful for tools like localization extractors.
    case text(_ text: String, comment: String? = nil)
    
    /// A localized string key to be resolved by SwiftUI.
    ///
    /// - Parameters:
    ///   - key: A `LocalizedStringKey` referring to a key in the `.strings` file.
    ///   - comment: An optional comment for context. Not used by `Text`,
    ///     but may be helpful for documentation or extraction.
    case localized(_ key: LocalizedStringKey, comment: String? = nil)
}

public extension Text {
    
    /// Initializes a `Text` view from a `DisplayedText` enum.
    ///
    /// This convenience initializer allows you to write code that supports both
    /// raw strings and localized keys without branching manually.
    ///
    /// Example:
    /// ```swift
    /// let title: DisplayedText = .localized("welcome_message")
    /// Text(title) // Will resolve as Text("welcome_message")
    /// ```
    ///
    /// - Parameter displayedText: The displayed text to use in the `Text` view.
    init(_ displayedText: DisplayedText) {
        switch displayedText {
        case .text(let text, _):
            self.init(text)
        case .localized(let key, _):
            self.init(key)
        }
    }
}

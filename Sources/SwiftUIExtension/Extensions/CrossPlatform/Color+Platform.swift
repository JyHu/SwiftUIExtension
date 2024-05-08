//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2023/12/12.
//

import SwiftUI

#if os(macOS)
public typealias NSUIColor = NSColor
#elseif os(iOS)
public typealias NSUIColor = UIColor
#endif


public extension Color {
    var gradient: AngularGradient {
        return AngularGradient(gradient: Gradient(colors: [self]), center: .center)
    }
    
    static var label: Color {
#if os(macOS)
        Color(.labelColor)
#else
        Color(.label)
#endif
    }
    
    static var tertiaryLabel: Color {
#if os(macOS)
        Color(.tertiaryLabelColor)
#else
        Color(.tertiaryLabel)
#endif
    }
    
    static var quaternaryLabel: Color {
#if os(macOS)
        Color(.quaternaryLabelColor)
#else
        Color(.quaternaryLabel)
#endif
    }
    
    static var link: Color {
#if os(macOS)
        Color(.linkColor)
#else
        Color(.link)
#endif
    }
    
    static var placeholderText: Color {
#if os(macOS)
        Color(.placeholderTextColor)
#else
        Color(.placeholderText)
#endif
    }
    
    static var separator: Color {
#if os(macOS)
        Color(.separatorColor)
#else
        Color(.separator)
#endif
    }
    
#if os(macOS)
    static var gridColor: Color {
        Color(.gridColor)
    }
#endif
    
    static var systemGroupedBackground: Color {
#if os(iOS)
        Color(.systemGroupedBackground)
#else
        Color(NSColor.windowBackgroundColor)
#endif
    }
    
    static var lightBackGround: Color {
        .secondary.opacity(0.1)
    }
}

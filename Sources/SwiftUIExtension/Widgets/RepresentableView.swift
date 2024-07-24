//
//  File.swift
//
//
//  Created by hujinyou on 2024/6/30.
//

import SwiftUI

#if canImport(AppKit)
import AppKit

public struct RepresentableNSView<T>: NSViewRepresentable where T: NSView {
    public typealias NSViewType = T
    
    public let nsview: T
    
    public init(nsview: T) {
        self.nsview = nsview
    }
    
    public func makeNSView(context: Context) -> T {
        return self.nsview
    }
    
    public func updateNSView(_ nsView: T, context: Context) { }
}

public struct RepresentableNSViewController<T>: NSViewControllerRepresentable where T: NSViewController {
    public typealias NSViewControllerType = T
    
    public let nsviewcontroller: T
    
    public init(nsviewcontroller: T) {
        self.nsviewcontroller = nsviewcontroller
    }
    
    public func makeNSViewController(context: Context) -> T {
        return self.nsviewcontroller
    }
    
    public func updateNSViewController(_ nsViewController: T, context: Context) { }
}

#elseif canImport(UIKit)

import UIKit

public struct RepresentableUIView<T>: UIViewRepresentable where T: UIView {
    public typealias UIViewType = T
    
    public let uiview: T
    
    public init(uiview: T) {
        self.uiview = uiview
    }
    
    public func makeUIView(context: Context) -> T {
        return self.uiview
    }
    
    public func updateUIView(_ uiView: T, context: Context) { }
}

public struct RepresentableUIViewController<T>: UIViewControllerRepresentable where T: UIViewController {
    public typealias UIViewControllerType = T
    
    public let uiviewcontroller: T
    
    public init(uiviewcontroller: T) {
        self.uiviewcontroller = uiviewcontroller
    }
    
    public func makeUIViewController(context: Context) -> T {
        return self.uiviewcontroller
    }
    
    public func updateUIViewController(_ uiViewController: T, context: Context) { }
}

#endif

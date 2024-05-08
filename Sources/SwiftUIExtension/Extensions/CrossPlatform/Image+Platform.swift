//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2022/8/22.
//

import SwiftUI

#if os(macOS)
import Cocoa
public typealias NSUIImage = NSImage
#elseif os(iOS)
import UIKit
public typealias NSUIImage = UIImage
#endif

public extension Image {
    init(image: NSUIImage) {
#if os(macOS)
        self.init(nsImage: image)
#elseif os(iOS)
        self.init(uiImage: image)
#endif
    }
}

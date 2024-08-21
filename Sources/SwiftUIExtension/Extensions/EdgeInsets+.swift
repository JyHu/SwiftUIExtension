//
//  SwiftUIView.swift
//  
//
//  Created by hujinyou on 2024/8/3.
//

import SwiftUI

public extension EdgeInsets {
    
    /// Create an `EdgeInsets` with different inset values for each edge.
    /// - Parameters:
    ///  - top: The inset value for the top edge.
    ///  - leading: The inset value for the leading edge.
    ///  - bottom: The inset value for the bottom edge.
    ///  - trailing: The inset value for the trailing edge.
    static func create(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) -> EdgeInsets {
        EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    /// Initialize an `EdgeInsets` with the same inset value for all edges.
    /// - Parameter padding: The inset value for all edges.
    init(all padding: CGFloat) {
        self.init(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
    
    /// Initialize an `EdgeInsets` with the same inset value for all edges.
    /// - Parameters:
    ///   - horizontal: The inset value for the horizontal edges.
    ///   - vertical: The inset value for the vertical edges
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}

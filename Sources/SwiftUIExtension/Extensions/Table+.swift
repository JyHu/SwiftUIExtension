//
//  SwiftUIView.swift
//  
//
//  Created by hujinyou on 2024/5/27.
//

import SwiftUI

@available(iOS 16.0, macOS 12.0, *)
extension Table {
    @ViewBuilder
    public func adp_tableColumnHeadersVisibility(_ visibility: Visibility = .hidden) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            tableColumnHeaders(visibility)
        }
    }
}

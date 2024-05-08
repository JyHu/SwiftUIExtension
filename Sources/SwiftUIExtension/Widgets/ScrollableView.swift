//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2022/8/28.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func scroll(
        offset: Binding<CGPoint>,
        axes: Axis.Set = .horizontal,
        showsIndicators: Bool = false,
        contentWidth: CGFloat? = nil,
        contentHeight: CGFloat? = nil
    ) -> some View {
        overlay(
            OffsetScrollView(axes: axes, showsIndicators: showsIndicators, offset: offset) {
                Color.clear
                    .frame(
                        width: contentWidth,
                        height: contentHeight
                    )
            }
        )
    }
}

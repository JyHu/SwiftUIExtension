//
//  LimitedChipsStack.swift
//
//
//  Created by Jo on 2026/5/31.
//
import SwiftUI
@available(iOS 16.0, macOS 13.0, *)
public struct LimitedChipsStack: Layout {
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    private let maxRows: Int?
    
    public init(spacing: CGFloat = 8, maxRows: Int? = nil ) {
        self.horizontalSpacing = spacing
        self.verticalSpacing = spacing
        self.maxRows = maxRows
    }
    
    public init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat, maxRows: Int? = nil) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.maxRows = maxRows
    }
    
    // MARK: - 关键：算可见范围
    private func visibleRange(maxWidth: CGFloat, subviews: Subviews) -> Range<Int> {
        guard maxWidth > 0 else {
            return subviews.indices
        }
        
        var row = 1
        var currentWidth: CGFloat = 0
        var lastIndex = subviews.startIndex
        
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let requiredWidth = currentWidth == 0 ? size.width : currentWidth + horizontalSpacing + size.width
            
            if requiredWidth > maxWidth {
                row += 1
                if let maxRows, row > maxRows {
                    return subviews.startIndex..<index
                }
                currentWidth = size.width
            } else {
                currentWidth = requiredWidth
            }
            
            lastIndex = index
        }
        
        return Range(subviews.startIndex...lastIndex)
    }
    // MARK: - size
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let range = visibleRange(maxWidth: maxWidth, subviews: subviews)
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var row = 1
        var maxX: CGFloat = 0
        
        for index in range {
            let size = subviews[index].sizeThatFits(.unspecified)
            let requiredWidth = x == 0 ? size.width : x + horizontalSpacing + size.width
            
            if requiredWidth > maxWidth {
                row += 1
                y += rowHeight + verticalSpacing
                
                if let maxRows, row > maxRows { break }
                
                x = size.width
                rowHeight = size.height
            } else {
                x = requiredWidth
                rowHeight = max(rowHeight, size.height)
            }
            maxX = max(maxX, x)
        }
        
        y += rowHeight
        
        return CGSize(width: maxX, height: y)
    }
    // MARK: - layout
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let range = visibleRange(maxWidth: bounds.width, subviews: subviews)
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for index in subviews.indices {
            let view = subviews[index]

            // 超出 maxRows 范围的 subview，放到屏幕外隐藏
            guard range.contains(index) else {
                view.place(at: CGPoint(x: -100000, y: -100000), proposal: .zero)
                continue
            }

            let size = view.sizeThatFits(.unspecified)
            let requiredWidth = x == bounds.minX ? size.width : (x - bounds.minX) + size.width

            if requiredWidth > bounds.width {
                x = bounds.minX
                y += rowHeight + verticalSpacing
                rowHeight = 0
            }

            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

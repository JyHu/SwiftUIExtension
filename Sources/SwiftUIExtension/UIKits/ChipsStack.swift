//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2024/1/31.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
public struct ChipsStack: Layout {
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat

    public init(spacing: CGFloat = 8) {
        self.init(horizontalSpacing: spacing, verticalSpacing: spacing)
    }

    public init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentRowWidth + size.width > maxWidth {
                totalHeight += currentRowHeight + verticalSpacing
                maxRowWidth = max(maxRowWidth, currentRowWidth)
                currentRowWidth = size.width
                currentRowHeight = size.height
            } else {
                let delta = currentRowWidth > 0 ? horizontalSpacing : 0
                currentRowWidth += delta + size.width
                currentRowHeight = max(currentRowHeight, size.height)
            }
        }

        totalHeight += currentRowHeight
        maxRowWidth = max(maxRowWidth, currentRowWidth)

        return CGSize(width: maxRowWidth, height: totalHeight)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + verticalSpacing
                rowHeight = 0
            }

            view.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )
            
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#if DEBUG

struct ChipsStack_Previews: PreviewProvider {
    static var previews: some View {
        ChipsStackPreview()
    }
    
    private static let vals: [String] = (0..<30).map { _ in Array(repeating: "#", count: Int.random(in: 0..<16) + 1).joined() }
    
    private struct ChipsStackPreview: View {
        var body: some View {
            if #available(iOS 16.0, macOS 13.0, *) {
                VStack {
                    ChipsStack(horizontalSpacing: 5, verticalSpacing: 2) {
                        ForEach(ChipsStack_Previews.vals, id: \.self) { val in
                            DebugView(val: val)
                        }
                    }
                    .padding()
                    .randomBackground
                }
                .frame(height: 300)
                .padding()
                .randomBackground
            }
        }
    }
    
    private struct DebugView: View {
        let val: String
        var body: some View {
            Text(val)
                .padding(.horizontal, 5)
                .randomBackground
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

#endif

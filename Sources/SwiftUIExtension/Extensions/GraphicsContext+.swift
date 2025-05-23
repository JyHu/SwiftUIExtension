//
//  GraphicsContext+.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/5/14.
//

import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension GraphicsContext {
    enum Alignment {
        case leading
        case trailing
        case center
    }
    
    func drawCenter(text: Text, in rect: CGRect, alignment: Alignment = .center, offset: Double = 5) {
        func calcX() -> Double {
            switch alignment {
            case .leading:
                return rect.minX + offset
            case .trailing:
                return rect.maxX - offset
            case .center:
                return (rect.size.width - fixedSize.width) / 2 + rect.minX
            }
        }
        
        // 设置文本样式
        let resolvedText = self.resolve(text)
        let fixedSize = resolvedText.measure(in: rect.size)

        // 指定绘制区域
        let textRect = CGRect(
            x: calcX(),
            y: (rect.size.height - fixedSize.height) / 2 + rect.minY,
            width: fixedSize.width,
            height: fixedSize.height
        )
        
        draw(text, in: textRect)
    }
}

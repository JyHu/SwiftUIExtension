//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2022/8/20.
//

import SwiftUI

public extension Color {
    static var random: Color {
        func g() -> Double {
            return Double(arc4random_uniform(256)) / 255.0
        }

        return Color(.sRGB, red: g(), green: g(), blue: g(), opacity: 1)
    }

    /// 默认的使用 RGBColorSpace=sRGB 创建颜色对象
    /// - Parameters:
    ///   - R: red, 0 ~ 255
    ///   - G: green, 0 ~ 255
    ///   - B: blue, 0 ~ 255
    ///   - A: alpha/opacity, 0 ~ 1
    init(_ colorSpace: Color.RGBColorSpace = .sRGB, R: Int, G: Int, B: Int, A: Double = 1) {
        self.init(colorSpace, red: CGFloat(R) / 255, green: CGFloat(G) / 255, blue: CGFloat(B) / 255, opacity: A)
    }
    
    init?(_ colorSpace: Color.RGBColorSpace = .sRGB, hexString: String) {
        var val: UInt64 = 0
        
        guard Scanner(string: hexString).scanHexInt64(&val) else { return nil }
        
        self.init(colorSpace, hexValue: val)
    }
    
    init(_ colorSpace: Color.RGBColorSpace = .sRGB, hexValue: UInt64) {
        self.init(colorSpace, R: Int(hexValue >> 16), G: Int((hexValue >> 8) & 0xFF), B: Int(hexValue & 0xFF))
    }
    
    func getRGB() -> (R: Int, G: Int, B: Int, A: Double) {
        let uiColor = NSUIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (R: Int(red * 255),
                G: Int(green * 255),
                B: Int(blue * 255),
                A: alpha)
    }
    
    var reversed: Color {
        let (r, g, b, _) = getRGB()
        return Color(R: 255 - r, G: 255 - g, B: 255 - b)
    }
    
    var hexValue: UInt {
        let (r, g, b, _) = getRGB()
        return ((UInt(r) << 8) + UInt(g)) << 8 + UInt(b)
    }
}


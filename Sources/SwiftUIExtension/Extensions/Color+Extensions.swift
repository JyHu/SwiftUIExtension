//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2022/8/20.
//

import SwiftUI

public extension Color {
    static var random: Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }

    /// 默认的使用 RGBColorSpace=sRGB 创建颜色对象
    /// - Parameters:
    ///   - R: red, 0 ~ 255
    ///   - G: green, 0 ~ 255
    ///   - B: blue, 0 ~ 255
    ///   - A: alpha/opacity, 0 ~ 1
    init(_ colorSpace: Color.RGBColorSpace = .sRGB, R: Int, G: Int, B: Int, A: Double = 1) {
        self.init(
            colorSpace,
            red: CGFloat(R) / 255,
            green: CGFloat(G) / 255,
            blue: CGFloat(B) / 255,
            opacity: A
        )
    }
    
    init?(_ colorSpace: Color.RGBColorSpace = .sRGB, hexString: String) {
        var val: UInt64 = 0
        
        guard Scanner(string: hexString).scanHexInt64(&val) else { return nil }
        
        self.init(colorSpace, hexValue: val)
    }
    
    init(_ colorSpace: Color.RGBColorSpace = .sRGB, hexValue: UInt64) {
        self.init(
            colorSpace,
            R: Int(hexValue >> 16),
            G: Int((hexValue >> 8) & 0xFF),
            B: Int(hexValue & 0xFF)
        )
    }
    
    func getRGB() -> (R: Int, G: Int, B: Int, A: Double) {
        let (red, green, blue, alpha) = getRgba()
        
        return (
            R: Int(red * 255),
            G: Int(green * 255),
            B: Int(blue * 255),
            A: alpha
        )
    }
    
    func getRgba() -> (r: Double, g: Double, b: Double, a: Double) {
        let uiColor = NSUIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (r: red, g: green, b: blue, a: alpha)
    }
    
    var reversed: Color {
        let (r, g, b, _) = getRGB()
        return Color(R: 255 - r, G: 255 - g, B: 255 - b)
    }
    
    var hexValue: UInt {
        let (r, g, b, _) = getRGB()
        return ((UInt(r) << 8) + UInt(g)) << 8 + UInt(b)
    }
    
    func toHex() -> String? {
        let (r, g, b, _) = getRGB()
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

public extension Color {
    /// 将颜色与白色混合，使颜色变淡（不改变 alpha）
    func lighten(by amount: CGFloat) -> Color {
        if amount <= 0 {
            return self
        }
        
        if amount >= 1 {
            return Color.white
        }
        
        let clamped = min(max(amount, 0), 1)

        // 将 SwiftUI Color 转为 UIColor / NSColor
        #if os(macOS)
        let nsColor = NSColor(self)
        guard let rgb = nsColor.usingColorSpace(.deviceRGB) else { return self }

        let red   = (1 - clamped) * rgb.redComponent   + clamped * 1.0
        let green = (1 - clamped) * rgb.greenComponent + clamped * 1.0
        let blue  = (1 - clamped) * rgb.blueComponent  + clamped * 1.0

        return Color(red: red, green: green, blue: blue)

        #else
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return self
        }

        red   = (1 - clamped) * red   + clamped * 1.0
        green = (1 - clamped) * green + clamped * 1.0
        blue  = (1 - clamped) * blue  + clamped * 1.0

        return Color(red: red, green: green, blue: blue)
        #endif
    }
}


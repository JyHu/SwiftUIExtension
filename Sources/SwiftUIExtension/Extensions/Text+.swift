//
//  SwiftUIView.swift
//  
//
//  Created by hujinyou on 2024/5/8.
//

import SwiftUI

public extension Text {
    init(_ number: Double, formatter: NumberFormatter) {
        self.init(NSNumber(value: number), formatter: formatter)
    }
    
    init(_ number: Int, formatter: NumberFormatter) {
        self.init(NSNumber(value: number), formatter: formatter)
    }
    
    init(_ number: UInt, formatter: NumberFormatter) {
        self.init(NSNumber(value: number), formatter: formatter)
    }
    
    init(_ number: Float, formatter: NumberFormatter) {
        self.init(NSNumber(value: number), formatter: formatter)
    }
    
    init(_ number: Int64, formatter: NumberFormatter) {
        self.init(NSNumber(value: number), formatter: formatter)
    }
    
    init(_ number: UInt64, formatter: NumberFormatter) {
        self.init(NSNumber(value: number), formatter: formatter)
    }
    
    init(_ number: Int32, formatter: NumberFormatter) {
        self.init(NSNumber(value: number), formatter: formatter)
    }
    
    init(_ number: UInt32, formatter: NumberFormatter) {
        self.init(NSNumber(value: number), formatter: formatter)
    }
}

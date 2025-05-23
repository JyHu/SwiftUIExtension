//
//  SelfCompatible.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/5/23.
//

import Foundation

public protocol SelfCompatible { }

public extension SelfCompatible {
    func makeValue<T>(builder: (Self) -> T) -> T {
        return builder(self)
    }
    
    func makeValue<T>(builder: (Self) -> T?) -> T? {
        return builder(self)
    }
}

extension NSObject: SelfCompatible { }

//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2022/9/5.
//

import SwiftUI


//
// class TestView {
//     var binder: OptionalBinder<String>?
//
//     func onChange(_ binder: Binding<String>) {
//         self.binder = OptionalBinder(value: binder)
//     }
//
//     func testAction() {
//         if let binder = binder {
//             binder.value = "test val"
//         }
//     }
// }
//


/// 可选的绑定对象
public struct OptionalBinder<T> {
    /// 用来绑定的值
    @Binding public var value: T
    public init(_ value: Binding<T>) {
        _value = value
    }
}

//
//  NumberField.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/2/8.
//

import SwiftUI

/// 定义数值输入兼容协议
public protocol InputedNumberKeyboardCompatible {
#if canImport(UIKit)
    static var keyboardType: UIKeyboardType { get }
#endif
}

/// 扩展数值类型以适配不同的键盘
public extension BinaryInteger where Self: InputedNumberKeyboardCompatible {
#if canImport(UIKit)
    static var keyboardType: UIKeyboardType { .numberPad }
#endif
}

public extension BinaryFloatingPoint where Self: InputedNumberKeyboardCompatible {
#if canImport(UIKit)
    static var keyboardType: UIKeyboardType { .decimalPad }
#endif
}

/// 让所有整数类型都符合协议
extension Int: InputedNumberKeyboardCompatible {}
extension Int8: InputedNumberKeyboardCompatible {}
extension Int16: InputedNumberKeyboardCompatible {}
extension Int32: InputedNumberKeyboardCompatible {}
extension Int64: InputedNumberKeyboardCompatible {}
extension UInt: InputedNumberKeyboardCompatible {}
extension UInt8: InputedNumberKeyboardCompatible {}
extension UInt16: InputedNumberKeyboardCompatible {}
extension UInt32: InputedNumberKeyboardCompatible {}
extension UInt64: InputedNumberKeyboardCompatible {}

/// 让浮点数类型符合协议
extension Double: InputedNumberKeyboardCompatible {}
extension Float: InputedNumberKeyboardCompatible {}

/// 通用的数值输入组件
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct NumberField<T: InputedNumberKeyboardCompatible>: View {

    private let formatter: NumberFormatter
    private let label: String?
    private let prompt: Text?
    
    @Binding private var value: T
    @FocusState private var isFocused: Bool
    
    /// 初始化方法
    /// - Parameters:
    ///  - label: 标签
    ///  - value: 绑定的值
    ///  - formatter: 格式化器
    ///  - prompt: 提示
    public init(_ label: String? = nil, value: Binding<T>, formatter: NumberFormatter = NumberField.defaultFormatter, prompt: String? = nil) {
        self.label = label
        self.formatter = formatter
        self._value = value
        self.prompt = prompt.map { Text($0) }
    }
    
    public var body: some View {
        makeField()
            .focused($isFocused)
#if canImport(UIKit)
            .keyboardType(T.keyboardType)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    if isFocused {
                        HStack {
                            Spacer()
                            Button("Done") { isFocused = false }
                                .font(.system(size: 15))
                        }
                    }
                }
            }
#endif
    }
    
    /// 创建输入框
    @ViewBuilder
    private func makeField() -> some View {
        if let label, !label.isEmpty {
            TextField(label, value: $value, formatter: formatter, prompt: prompt)
        } else {
            TextField("", value: $value, formatter: formatter, prompt: prompt)
                .labelsHidden()
        }
    }
    
    /// 默认的数值格式化器
    public static var defaultFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter
    }
}


#if DEBUG
struct NumberField_Previews: PreviewProvider {
    static var previews: some View {
        NumberFieldPreview()
            .previewDisplayName("NumberField 示例")
    }
    
    private struct NumberFieldPreview: View {
        @State var n1: Int = 0
        @State var n2: Int8 = 0
        @State var n3: Int16 = 0
        @State var n4: Int32 = 0
        @State var n5: Int64 = 0
        @State var n6: UInt = 0
        @State var n7: UInt8 = 0
        @State var n8: UInt16 = 0
        @State var n9: UInt32 = 0
        @State var n10: UInt64 = 0
        
        @State var n11: Double = 0
        @State var n12: Float = 0
        
        var body: some View {
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                ScrollView {
                    GroupBox("Int") {
                        VStack(alignment: .leading) {
                            NumberField("Int", value: $n1)
                            NumberField("Int8", value: $n2)
                            NumberField("Int16", value: $n3)
                            NumberField("Int32", value: $n4)
                            NumberField("Int64", value: $n5)
                        }
                    }
                    
                    GroupBox("UInt") {
                        VStack(alignment: .leading) {
                            NumberField("UInt", value: $n6)
                            NumberField("UInt8", value: $n7)
                            NumberField("UInt16", value: $n8)
                            NumberField("UInt32", value: $n9)
                            NumberField("UInt64", value: $n10)
                        }
                    }
                    
                    GroupBox("Float") {
                        VStack(alignment: .leading) {
                            NumberField("Double", value: $n11)
                            NumberField("Float", value: $n12)
                        }
                    }
                }
            }
        }
    }
}
#endif

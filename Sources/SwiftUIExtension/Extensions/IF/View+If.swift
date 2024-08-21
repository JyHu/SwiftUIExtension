//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2023/12/13.
//

import SwiftUI

public extension View {
    
    /// 根据输入条件来判断是否应用对视图的扩展方法
    /// 比如对一个view想要加背景色，但是需要在选中状态下才加否则就不加，使用示例如下：
    ///
    ///   ```
    ///   Text("Hello")
    ///       .if(isSelected) {
    ///           $0.background(in: RoundedRectangle(cornerRadius: 5))
    ///       }
    ///   ```
    ///
    /// - Parameters:
    ///   - condition: 判断条件
    ///   - transform: 对视图的转换处理
    /// - Returns: 处理后的方法
    @ViewBuilder
    func `if`(_ condition: Bool, @ViewBuilder transform: (Self) -> some View) -> some View {
        if condition { transform(self) }
        else { self }
    }
    
    @ViewBuilder
    func `if`(_ condition: Bool, @ViewBuilder transForm: (Self) -> some View, @ViewBuilder else elseTransform: (Self) -> some View) -> some View {
        if condition {
            transForm(self)
        } else {
            elseTransform(self)
        }
    }
    
    /// 用于在数据存在的情况下对视图做修饰扩展
    /// 比如我们有一个圆角的数据 radius，我需要在这个值存在的时候对text添加一个圆角，否则就不管
    ///
    ///   ```
    ///   let radius: Double? = 10
    ///   Text("Hello")
    ///       .if(radius) {
    ///           $0.background(in: RoundedRectangle(cornerRadius: $1))
    ///       }
    ///   ```
    ///
    /// - Parameters:
    ///   - data: 需要判断有效的数据
    ///   - defaultValue: 默认的数据，在data为空的时候使用
    ///   - transform: 转换方法
    /// - Returns: 处理后的视图
    @ViewBuilder
    func `if`<D>(_ data: D?, default defaultValue: D? = nil, @ViewBuilder transform: (Self, D) -> some View) -> some View  {
        if let data = data ?? defaultValue {
            transform(self, data )
        } else {
            self
        }
    }
    
    /// 在条件满足的时候对view应用modifier
    /// - Parameters:
    ///   - condition: 需要判断的条件
    ///   - modifier: modifier
    /// - Returns: 应用了modifier后的视图
    @ViewBuilder
    func modifier<T>(if condition: Bool, _ modifier: T) -> some View where T: ViewModifier {
        if condition {
            self.modifier(modifier)
        } else {
            self
        }
    }
    
    /// 根据输入条件的true/false来决定使用对应的modifier
    /// - Parameters:
    ///   - condition: 判断条件
    ///   - trueModifier: 输入条件为true的时候应用的modifier
    ///   - falseModifier: 输入条件为false的时候应用的modifier
    /// - Returns: 应用 modifier 后的视图
    @ViewBuilder
    func modifier<M1, M2>(if condition: Bool, `true` trueModifier: M1, false falseModifier: M2) -> some View where M1: ViewModifier, M2: ViewModifier {
        if condition {
            self.modifier(trueModifier)
        } else {
            self.modifier(falseModifier)
        }
    }
}

@available(iOS 15.0, macOS 12.0, watchOS 8.0, *)
@available(tvOS, unavailable)
public extension View {
    @ViewBuilder
    func swipeActions<T>(if condition: Bool, edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: () -> T) -> some View where T : View {
        self.if(condition) {
            $0.swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe, content: content)
        }
    }
    
    func swipeActions<T, D>(if data: D?, default defaultValue: D?, edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: (D) -> T) -> some View where T : View {
        self.if(data, default: defaultValue) { transformSelf, data in
            transformSelf.swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe) {
                content(data)
            }
        }
    }
}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func preferredColorScheme(if condition: Bool, colorScheme: ColorScheme?) -> some View {
        self.if(condition) {
            $0.preferredColorScheme(colorScheme)
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func background<S>(if condition: Bool, in shape: S, fillStyle: FillStyle = FillStyle()) -> some View where S : InsettableShape {
        self.if(condition) { view in
            view.background(in: shape, fillStyle: fillStyle)
        }
    }
    
    func background<S, T>(if condition: Bool, style: T, in shape: S, fillStyle: FillStyle = FillStyle()) -> some View where S : InsettableShape, T: ShapeStyle {
        self.if(condition) { view in
            view.background(style, in: shape, fillStyle: fillStyle)
        }
    }
    
    func background<V>(if condition: Bool, alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
        self.if(condition) { view in
            view.background(alignment: alignment, content: content)
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func background<S>(if condition: Bool, style: S, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View where S : ShapeStyle {
        self.if(condition) {
            $0.background(style, ignoresSafeAreaEdges: edges)
        }
    }
}

public extension View {
    @ViewBuilder
    func labelsHidden(if condition: Bool) -> some View {
        self.if(condition) {
            $0.labelsHidden()
        }
    }
}

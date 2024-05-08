//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2022/8/28.
//

import SwiftUI

/// ScrollView偏移量缓存的key
fileprivate struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    /// 默认值
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
    typealias Value = CGPoint
}

/// 可以监听偏移量变化的scrollView
public struct OffsetScrollView<Content: View>: View {
    private enum _MonitorType {
        case block
        case binding
    }
    
    /// 视图id，用于坐标系的转换
    private let layerID = UUID().uuidString
    /// 偏移量发生改变后的回调
    private var offsetChangedBlock: ((CGPoint) -> Void)?
    /// 创建滚动视图的回调
    private var contentBuilder: () -> Content
    /// 显示方向坐标系
    private var axes: Axis.Set
    /// 是否显示滚动指示器
    private var showsIndicators: Bool
    /// 绑定偏移量的变化
    @Binding var offset: CGPoint
    
    private var monitorType: _MonitorType = .block
    
    /// 初始化方法
    /// - Parameters:
    ///   - offsetChanged: 偏移量发生改变后的回调
    ///   - contentBuilder: 创建滚动视图的回调
    public init(axes: Axis.Set = .vertical, showsIndicators: Bool = true, onOffsetChanged: @escaping (CGPoint) -> Void, @ViewBuilder contentBuilder: @escaping () -> Content) {
        self.offsetChangedBlock = onOffsetChanged
        self.contentBuilder = contentBuilder
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.monitorType = .block
        _offset = .constant(.zero)
    }
    
    public init(axes: Axis.Set = .vertical, showsIndicators: Bool = true, offset: Binding<CGPoint>, @ViewBuilder contentBuilder: @escaping () -> Content) {
        self.contentBuilder = contentBuilder
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.monitorType = .binding
        _offset = offset
    }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            /// 添加一个透明视图，用于监听滚动偏移量
            GeometryReader { proxy in
                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: proxy.frame(in: .named(layerID)).origin)
            }
            /// 添加显示视图
            contentBuilder()
        }
        /// 设置坐标系id
        .coordinateSpace(name: layerID)
        /// 在视图偏移量发生改变后回调
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { ofs in
            if monitorType == .binding {
                offset = ofs
            } else {
                offsetChangedBlock?(ofs)
            }
        }
    }
}

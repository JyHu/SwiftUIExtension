//
//  SwiftUIView.swift
//
//
//  Created by hujinyou on 2024/8/3.
//

import SwiftUI

// MARK: - 样式类型定义

public enum CActionButtonStyle {
    case normal
    case primary
    case destructive
    case custom(background: Color, label: Color)

    var backgroundColor: Color {
        switch self {
        case .normal: .lightBackGround
        case .primary: .accentColor
        case .destructive: Color(.systemRed)
        case .custom(let background, _): background
        }
    }

    var labelColor: Color {
        switch self {
        case .normal: .label
        case .primary, .destructive: .white
        case .custom(_, let label): label
        }
    }
}

// MARK: - 尺寸和布局结构体

private struct CActionButtonSize {
    var width: CGFloat?
    var height: CGFloat?
    var alignment: Alignment = .center
}

private struct CActionButtonFrame {
    var minWidth: CGFloat?
    var idealWidth: CGFloat?
    var maxWidth: CGFloat?
    var minHeight: CGFloat?
    var idealHeight: CGFloat?
    var maxHeight: CGFloat?
    var alignment: Alignment = .center
}

// MARK: - EnvironmentKey 定义

private enum CAEnvironmentKeys {
    struct CAButtonSizeKey: EnvironmentKey {
        static var defaultValue: CActionButtonSize? = nil
    }

    struct CAButtonFrameKey: EnvironmentKey {
        static var defaultValue: CActionButtonFrame? = nil
    }

    struct CAButtonEdgeInsetsKey: EnvironmentKey {
        static var defaultValue: EdgeInsets = EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
    }

    struct CAButtonCornerRadiusKey: EnvironmentKey {
        static var defaultValue: CGFloat = 5
    }
}

private extension EnvironmentValues {
    var caButtonSize: CActionButtonSize? {
        get { self[CAEnvironmentKeys.CAButtonSizeKey.self] }
        set { self[CAEnvironmentKeys.CAButtonSizeKey.self] = newValue }
    }

    var caButtonFrame: CActionButtonFrame? {
        get { self[CAEnvironmentKeys.CAButtonFrameKey.self] }
        set { self[CAEnvironmentKeys.CAButtonFrameKey.self] = newValue }
    }

    var caButtonPadding: EdgeInsets {
        get { self[CAEnvironmentKeys.CAButtonEdgeInsetsKey.self] }
        set { self[CAEnvironmentKeys.CAButtonEdgeInsetsKey.self] = newValue }
    }

    var caButtonCornerRadius: CGFloat {
        get { self[CAEnvironmentKeys.CAButtonCornerRadiusKey.self] }
        set { self[CAEnvironmentKeys.CAButtonCornerRadiusKey.self] = newValue }
    }
}

// MARK: - CActionButton 主体组件

public struct CActionButton<Label: View>: View {
    private let content: Label
    private let style: CActionButtonStyle
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.caButtonSize) private var size
    @Environment(\.caButtonFrame) private var frame
    @Environment(\.caButtonPadding) private var padding
    @Environment(\.caButtonCornerRadius) private var radius

    @State private var isHovering: Bool = false

    public init(style: CActionButtonStyle = .normal, action: @escaping () -> Void, @ViewBuilder content: () -> Label) {
        self.style = style
        self.action = action
        self.content = content()
    }

    public var body: some View {
        Button {
            if isEnabled { action() }
        } label: {
            let ctx = content
                .padding(padding)
                .modifier(ApplySizeModifier(size: size))
                .modifier(ApplyFrameModifier(frame: frame))
                .foregroundColor(style.labelColor.opacity(opacity(isEnabled)))
            
            if #available(iOS 15.0, macOS 12.0, *) {
                let bg = RoundedRectangle(cornerRadius: radius)
                    .fill(style.backgroundColor.opacity(opacity(isEnabled)))
                ctx.background(bg)
            } else {
                ctx.cornerRadius(radius)
            }
        }
        .buttonStyle(.borderless)
        .onHover { isHovering = $0 }
    }

    private func opacity(_ enabled: Bool) -> CGFloat {
        enabled ? (isHovering ? 0.9 : 1.0) : 0.7
    }
}

// MARK: - 尺寸与框架 Modifier

private struct ApplySizeModifier: ViewModifier {
    let size: CActionButtonSize?

    func body(content: Content) -> some View {
        if let size {
            content.frame(width: size.width, height: size.height, alignment: size.alignment)
        } else {
            content
        }
    }
}

private struct ApplyFrameModifier: ViewModifier {
    let frame: CActionButtonFrame?

    func body(content: Content) -> some View {
        if let frame {
            content.frame(
                minWidth: frame.minWidth,
                idealWidth: frame.idealWidth,
                maxWidth: frame.maxWidth,
                minHeight: frame.minHeight,
                idealHeight: frame.idealHeight,
                maxHeight: frame.maxHeight,
                alignment: frame.alignment
            )
        } else {
            content
        }
    }
}

// MARK: - View 环境设置扩展

public extension View {
    func caButtonFrame(
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        let frame = CActionButtonFrame(
            minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth,
            minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight,
            alignment: alignment
        )
        return environment(\.caButtonFrame, frame)
    }

    func caButtonSize(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        let size = CActionButtonSize(width: width, height: height, alignment: alignment)
        return environment(\.caButtonSize, size)
    }

    func caButtonPadding(_ insets: EdgeInsets) -> some View {
        environment(\.caButtonPadding, insets)
    }

    func caButtonCornerRadius(_ radius: CGFloat) -> some View {
        environment(\.caButtonCornerRadius, radius)
    }
}

// MARK: - 快捷初始化

public extension CActionButton where Label == Text {
    init(_ label: String, style: CActionButtonStyle = .normal, action: @escaping () -> Void) {
        self.init(style: style, action: action) {
            Text(label)
        }
    }
}

public extension CActionButton where Label == Image {
    init(image: Image, style: CActionButtonStyle = .normal, action: @escaping () -> Void) {
        self.init(style: style, action: action) {
            image
        }
    }

    init(imageName: String, style: CActionButtonStyle = .normal, action: @escaping () -> Void) {
        self.init(style: style, action: action) {
            Image(imageName)
        }
    }

    init(systemImageName: String, style: CActionButtonStyle = .normal, action: @escaping () -> Void) {
        self.init(style: style, action: action) {
            Image(systemName: systemImageName)
        }
    }
}

#if DEBUG

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonPreview()
    }
    
    private struct ActionButtonPreview: View {
        var body: some View {
            VStack {
                CActionButton("Hello", style: .primary) {
                    print("Hello")
                }
                .caButtonPadding(EdgeInsets(all: 10))
            }
            .frame(width: 500, height: 500)
        }
    }
}

#endif

//
//  SwiftUIView.swift
//
//
//  Created by hujinyou on 2024/8/3.
//

import SwiftUI

fileprivate class _ActionButtonSize {
    var width: CGFloat?
    var height: CGFloat?
    var alignment: Alignment = .center
}

fileprivate class _ActionButtonFrame {
    var minWidth: CGFloat?
    var idealWidth: CGFloat?
    var maxWidth: CGFloat?
    var minHeight: CGFloat?
    var idealHeight: CGFloat?
    var maxHeight: CGFloat?
    var alignment: Alignment = .center
}

private class _ActionButtonViewModel: ObservableObject {
    @Published var style: CActionButtonStyle = .normal
    @Published var isDisabled: Bool = false
    @Published var isHovering: Bool = false
    @Published var edges = EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
    @Published var cornerRadius: Double = 5
    @Published var frame: _ActionButtonFrame?
    @Published var size: _ActionButtonSize?
    
    init(style: CActionButtonStyle) {
        self.style = style
    }
    
    var opacityValue: CGFloat {
        return isDisabled ? 0.7 : (isHovering ? 0.9 : 1.0)
    }
    
    var foregroundColor: Color {
        style.labelColor.opacity(opacityValue)
    }
    
    var backgroundColor: Color {
        style.backgroundColor.opacity(opacityValue)
    }
}

public enum CActionButtonStyle {
    case normal
    case primary
    case destructive
    case custom(background: Color, label: Color)
    
    fileprivate var backgroundColor: Color {
        switch self {
        case .normal: .lightBackGround
        case .primary: .link
        case .destructive: Color(.systemRed)
        case .custom(background: let background, label: _): background
        }
    }
    
    fileprivate var labelColor: Color {
        switch self {
        case .normal: .label
        case .primary: .white
        case .destructive: .white
        case .custom(background: _, label: let label): label
        }
    }
}

public struct CActionButton<V: View>: View {
    private let content: V
    private let action: () -> Void
    
    @ObservedObject private var viewModel: _ActionButtonViewModel
    
    public var body: some View {
        Button {
            if !viewModel.isDisabled {
                action()
            }
        } label: {
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                content
                    .padding(viewModel.edges)
                    .apply(size: viewModel.size)
                    .apply(frame: viewModel.frame)
                    .foregroundColor(viewModel.foregroundColor)
                    .background(viewModel.backgroundColor)
                    .background(in: RoundedRectangle(cornerRadius: viewModel.cornerRadius))
            } else {
                content
                    .padding(viewModel.edges)
                    .apply(size: viewModel.size)
                    .apply(frame: viewModel.frame)
                    .foregroundColor(viewModel.foregroundColor)
                    .background(viewModel.backgroundColor)
                    .cornerRadius(viewModel.cornerRadius)
            }
        }
        .buttonStyle(.borderless)
        .contentShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius))
        .onHover {
            viewModel.isHovering = $0
        }
    }
}

public extension CActionButton {
    init(style: CActionButtonStyle = .normal, action: @escaping () -> Void, @ViewBuilder content: () -> V) {
        self.viewModel = _ActionButtonViewModel(style: style)
        self.content = content()
        self.action = action
    }
}

public extension CActionButton where V == Text {
    init(_ label: String, style: CActionButtonStyle = .normal, action: @escaping () -> Void) {
        self.viewModel = _ActionButtonViewModel(style: style)
        self.content = Text(label)
        self.action = action
    }
}

public extension CActionButton where V == Image {
    init(image: Image, style: CActionButtonStyle = .normal, action: @escaping () -> Void) {
        self.viewModel = _ActionButtonViewModel(style: style)
        self.content = image
        self.action = action
    }
    
    init(imageName: String, style: CActionButtonStyle = .normal, action: @escaping () -> Void) {
        self.viewModel = _ActionButtonViewModel(style: style)
        self.content = Image(imageName)
        self.action = action
    }
    
    init(systemImageName: String, style: CActionButtonStyle = .normal, action: @escaping () -> Void) {
        self.viewModel = _ActionButtonViewModel(style: style)
        self.content = Image(systemName: systemImageName)
        self.action = action
    }
}

public extension CActionButton {
    func disabled(_ isDisabled: Bool) -> Self {
        viewModel.isDisabled = isDisabled
        return self
    }
    
    func apply(cornerRadius: Double) -> Self {
        viewModel.cornerRadius = cornerRadius
        return self
    }
    
    func apply(edges: EdgeInsets) -> Self {
        viewModel.edges = edges
        return self
    }
    
    func apply(style: CActionButtonStyle) -> Self {
        viewModel.style = style
        return self
    }
    
    func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> Self {
        
        if viewModel.frame == nil {
            viewModel.frame = _ActionButtonFrame()
        }
        
        viewModel.frame?.minWidth = minWidth
        viewModel.frame?.idealWidth = idealWidth
        viewModel.frame?.maxWidth = maxWidth
        viewModel.frame?.minHeight = minHeight
        viewModel.frame?.idealHeight = idealHeight
        viewModel.frame?.maxHeight = maxHeight
        viewModel.frame?.alignment = alignment
        
        return self
    }
    
    func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> Self {
        
        if viewModel.size == nil {
            viewModel.size = _ActionButtonSize()
        }
        
        viewModel.size?.width = width
        viewModel.size?.height = height
        
        return self
    }
}

private extension View {
    @ViewBuilder
    func apply(size: _ActionButtonSize?) -> some View {
        if let size {
            self.frame(width: size.width, height: size.height, alignment: size.alignment)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func apply(frame: _ActionButtonFrame?) -> some View {
        if let frame {
            self.frame(minWidth: frame.minWidth, idealWidth: frame.idealWidth, maxWidth: frame.maxWidth, minHeight: frame.minHeight, idealHeight: frame.idealHeight, maxHeight: frame.maxHeight, alignment: frame.alignment)
        } else {
            self
        }
    }
}

#Preview {
    VStack {
        CActionButton(style: .destructive) {
            
        } content: {
            Label("Heart", systemImage: "heart")
        }
        
        CActionButton(systemImageName:"moon.stars.fill", style: .normal) {
            
        }
        
        
        CActionButton("hello", style: .primary) {
            
        }
        .apply(edges: EdgeInsets(horizontal: 10, vertical: 5))
        .apply(cornerRadius: 5)
        
        CActionButton(systemImageName: "plus", style: .destructive) {
            
        }
        .apply(edges: .create(top: 10, leading: 20, bottom: 15, trailing: 0))
        .apply(cornerRadius: 5)
        .disabled(true)
        
        CActionButton(systemImageName: "plus", style: .custom(background: .red, label: .white)) {
            
        }
        .apply(edges: EdgeInsets(all: 5))
        .apply(cornerRadius: 5)
    }
    .padding(.all, 30)
    .background(Color.yellow.opacity(0.5))
}

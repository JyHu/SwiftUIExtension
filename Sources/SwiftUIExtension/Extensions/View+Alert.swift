//
//  File.swift
//  
//
//  Created by Jo on 2024/2/3.
//

import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
private struct AlertContentModifier: ViewModifier {
    @Binding var content: AlertContent?

    func body(content view: Content) -> some View {
        view.alert(
            content?.title ?? "",
            isPresented: Binding(
                get: { content != nil },
                set: { if !$0 { content = nil } }
            )
        ) {
            if let actions = content?.actions {
                ForEach(actions) { action in
                    Button(action.title, role: action.role) {
                        action.action()
                    }
                }
            }
        } message: {
            if let message = content?.message {
                Text(message)
            }
        }
    }
}

// MARK: - AlertAction

/// Alert 中的单个按钮。
@available(iOS 15.0, macOS 12.0, *)
public struct AlertAction: Identifiable {
    public var id = UUID()
    let title: String
    let role: ButtonRole?
    let action: () -> Void

    /// - Parameters:
    ///   - title: 按钮文字
    ///   - role: 按钮角色（.destructive / .cancel / nil 为普通按钮）
    ///   - action: 点击回调
    public init(title: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.role = role
    }
}

// MARK: - AlertContent

/// 描述一个完整 Alert 的数据模型。
/// 赋值给 @State var alertContent 即触发弹窗，置 nil 即关闭。
@available(iOS 15.0, macOS 12.0, *)
public struct AlertContent: Identifiable {
    public var id = UUID()
    let title: String
    let message: String
    let actions: [AlertAction]

    /// 完整自定义初始化（多按钮场景）。
    /// - Parameters:
    ///   - title: 标题，默认 "温馨提示"
    ///   - message: 提示内容
    ///   - actions: 按钮数组，为空时仅显示标题和消息
    public init(_ title: String, message: String, actions: [AlertAction] = []) {
        self.title = title
        self.message = message
        self.actions = actions
    }

    /// 单按钮弹窗（普通确认，无 destructive 角色）。
    /// - Parameters:
    ///   - title: 标题，默认 "温馨提示"
    ///   - message: 提示内容
    ///   - action: 确认回调
    ///
    /// 面向业务的简单封装
    /// ```
    /// static func tips(_ title: String = "温馨提示", message: String, action: @escaping () -> Void) -> AlertContent {
    ///     AlertContent(title, message: message, confirmButtonTitle: "确定", action: action)
    /// }
    /// ```
    ///
    public init(_ title: String, message: String, confirmButtonTitle: String = "OK", action: @escaping () -> Void) {
        self.init(title, message: message, actions: [
            AlertAction(title: confirmButtonTitle, action: action)
        ])
    }

    /// 单按钮弹窗（destructive 确认，用于危险操作）。
    /// - Parameters:
    ///   - title: 标题，默认 "温馨提示"
    ///   - confirmedMessage: 提示内容
    ///   - action: 确认回调
    ///
    /// 面向业务的简单封装
    /// ```
    /// static func confirm(_ title: String = "温馨提示", message: String, action: @escaping () -> Void) -> AlertContent {
    ///     AlertContent(title, confirmedMessage: message, cancelButtonTitle: "取消", confirmButtonTitle: "确定", action: action)
    /// }
    /// ```
    ///
    public init(_ title: String, confirmedMessage: String, cancelButtonTitle: String = "Cancel", confirmButtonTitle: String = "Confirm", action: @escaping () -> Void) {
        self.init(title, message: confirmedMessage, actions: [
            AlertAction(title: cancelButtonTitle, role: .cancel, action: { }),
            AlertAction(title: confirmButtonTitle, role: .destructive, action: action)
        ])
    }
}

// MARK: - View Extension

@available(iOS 15.0, macOS 12.0, *)
public extension View {
    /// 绑定数据驱动的 Alert。
    /// - Parameter content: AlertContent 的 Binding，非 nil 时弹出，dismiss 后自动置 nil。
    @ViewBuilder
    func alert(_ content: Binding<AlertContent?>) -> some View {
        modifier(AlertContentModifier(content: content))
    }
}

public struct AlertPattern {
    let title: String
    let message: String?
    let confirmTitle: String
    let cancelTitle: String
    
    public init(title: String, message: String? = nil, confirmTitle: String? = nil, cancelTitle: String? = nil) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle ?? "Confirm"
        self.cancelTitle = cancelTitle ?? "Cancel"
    }
    
    static func create(title: String, message: String? = nil, confirmTitle: String? = nil, cancelTitle: String? = nil) -> AlertPattern {
        return AlertPattern(title: title, message: message, confirmTitle: confirmTitle, cancelTitle: cancelTitle)
    }
    
    static var `default`: AlertPattern {
        AlertPattern(title: "")
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct InputedAlertView<Content: View>: View {
    let alertPattern: AlertPattern
    let sourceView: (@escaping () -> Void) -> Content
    let confirmedAction: (String) -> Void
    let validation: ((String) -> Bool)?
    
    @State private var isShowing: Bool = false
    @State private var inputText: String = ""
    
    public init(alertPattern: AlertPattern? = nil, sourceView: @escaping (@escaping () -> Void) -> Content, confirmedAction: @escaping (String) -> Void, validation: ( (String) -> Bool)? = nil) {
        self.alertPattern = alertPattern ?? AlertPattern(title: "")
        self.sourceView = sourceView
        self.confirmedAction = confirmedAction
        self.validation = validation
        self.isShowing = isShowing
    }
    
    public init(title: String, sourceView: @escaping (@escaping () -> Void) -> Content, confirmedAction: @escaping (String) -> Void, validation: ( (String) -> Bool)? = nil) {
        self.alertPattern = AlertPattern(title: title)
        self.sourceView = sourceView
        self.confirmedAction = confirmedAction
        self.validation = validation
        self.isShowing = isShowing
    }
    
    public var body: some View {
        sourceView {
            self.isShowing = true
        }
        .alert(alertPattern.title, isPresented: $isShowing) {
            TextField(text: $inputText, label: { })
            
            Button(alertPattern.confirmTitle) {
                confirmedAction(inputText)
            }
            .disabled(!(validation?(inputText) ?? true) || inputText.count == 0)
            
            Button(alertPattern.cancelTitle) { }
        } message: {
            if let message = alertPattern.message {
                Text(message)
            }
        }
    }
}

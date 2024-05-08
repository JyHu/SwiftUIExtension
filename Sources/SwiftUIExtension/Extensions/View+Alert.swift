//
//  File.swift
//  
//
//  Created by Jo on 2024/2/3.
//

import SwiftUI

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

public struct ConfirmedView<Content: View>: View {
    let alertPattern: AlertPattern
    let sourceView: ( @escaping () -> Void) -> Content
    let confirmedAction: () -> Void
    
    @State private var isShowing: Bool = false
    
    public init(title: String, @ViewBuilder sourceView: @escaping (@escaping () -> Void) -> Content, confirmedAction: @escaping () -> Void) {
        self.alertPattern = AlertPattern(title: title)
        self.sourceView = sourceView
        self.confirmedAction = confirmedAction
    }
    
    public init(alertPattern: AlertPattern?, @ViewBuilder sourceView: @escaping (@escaping () -> Void) -> Content, confirmedAction: @escaping () -> Void) {
        self.alertPattern = alertPattern ?? AlertPattern(title: "")
        self.sourceView = sourceView
        self.confirmedAction = confirmedAction
    }
    
    public var body: some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            sourceView {
                self.isShowing = true
            }
            .alert(alertPattern.title, isPresented: $isShowing) {
                Button(alertPattern.confirmTitle, action: {
                    self.confirmedAction()
                    self.isShowing = false
                })
                Button(alertPattern.cancelTitle, action: { self.isShowing = false })
            } message: {
                if let message = alertPattern.message {
                    Text(message)
                }
            }
        } else {
            sourceView {
                self.isShowing = true
            }
            .alert(isPresented: $isShowing) {
                if let message = alertPattern.message {
                    Alert(
                        title: Text(alertPattern.title),
                        message: Text(message),
                        primaryButton: .default(
                            Text(alertPattern.confirmTitle),
                            action: confirmedAction
                        ),
                        secondaryButton: .cancel(
                            Text(alertPattern.cancelTitle),
                            action: { }
                        )
                    )
                } else {
                    Alert(
                        title: Text(alertPattern.title),
                        primaryButton: .default(
                            Text(alertPattern.confirmTitle),
                            action: confirmedAction
                        ),
                        secondaryButton: .cancel(
                            Text(alertPattern.cancelTitle),
                            action: { }
                        )
                    )
                }
            }
        }
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

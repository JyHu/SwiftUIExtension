//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/12.
//

import SwiftUI

/// 带有自定义返回按钮的视图
struct BackableView<T>: View where T: View {
    #if os(iOS)
    @Environment(\.presentationMode) var presentationMode
    #endif
    
    let contentMaker: () -> T
    
    var body: some View {
        contentMaker()
        #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                    }
                }
            }
        #endif
    }
}

/// 根据平台来确定是自定义返回按钮还是直接跳转到的新页面
struct PlatformPopableView<T>: View where T: View {
    @Environment(\.presentationMode) var presentationMode
    
    let contentMaker: () -> T
    
    var body: some View {
        if Platform.current == .iphone {
            contentMaker()
        } else {
            BackableView(contentMaker: contentMaker)
        }
    }
}

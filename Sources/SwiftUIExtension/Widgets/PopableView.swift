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
//
//public struct PresentedView<C, T>: View where C: View, T: View {
//    /// 弹出方式
//    public enum PresentMode {
//        case sheet
//        case popover(_ size: CGSize)
//    }
//    
//    public let content: () -> C
//    public let target: () -> T
//    public let isNavigatable: Bool
//    public let mode: PresentMode
//    
//    @State private var isPresented: Bool = false
//    
//    @Environment(\.presentationMode) private var presentationMode
//    
//    public init(content: @escaping () -> C, target: @escaping () -> T, isNavigatable: Bool = true, mode: PresentMode = .sheet) {
//        self.content = content
//        self.target = target
//        self.isNavigatable = isNavigatable
//        self.mode = mode
//    }
//    
//    public var body: some View {
//        let sourceView = Group {
//            if #available(iOS 15.0, *) {
//                content()
//                    .overlay {
//                        Button(" ") {
//                            isPresented = true
//                        }
//                    }
//            } else {
//                Button {
//                    isPresented
//                } label: {
//                    content()
//                }
//            }
//        }
//        
//        let targetView = Group {
//            if isNavigatable {
//                let tmpView = target()
//                    .toolbar {
//                        ToolbarItem(placement: .topBarLeading) {
//                            Button {
//                                presentationMode.wrappedValue.dismiss()
//                            } label: {
//                                Image(systemName: "")
//                            }
//                        }
//                    }
//                
//                if #available(iOS 16.0, *) {
//                    NavigationStack {
//                        tmpView
//                    }
//                } else {
//                    NavigationView {
//                        tmpView
//                    }
//                }
//            } else {
//                target()
//            }
//        }
//        
//        switch mode {
//        case .sheet:
//            sourceView.sheet(isPresented: $isPresented) {
//                targetView
//            }
//        case .popover(let _):
//            sourceView.popover(isPresented: $isPresented) {
//                targetView
//            }
//        }
//    }
//}

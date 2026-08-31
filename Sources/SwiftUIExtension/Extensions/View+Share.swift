//
//  View+Share.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2026/6/17.
//

import SwiftUI

#if os(iOS)

public extension View {
    @ViewBuilder
    func share(_ item: Any, show: Binding<Bool>) -> some View {
        self.share([item], show: show)
    }
    
    @ViewBuilder
    func share(_ items: [Any], show: Binding<Bool>) -> some View {
        self.sheet(isPresented: show) {
            ShareSheet(items: items)
        }
    }
    
    @ViewBuilder
    func share<T>(_ item: Binding<T?>) -> some View where T: Identifiable {
        self.sheet(item: item) {
            ShareSheet(items: [$0])
        }
    }
}

// MARK: - ShareSheet (UIKit bridge)

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#endif

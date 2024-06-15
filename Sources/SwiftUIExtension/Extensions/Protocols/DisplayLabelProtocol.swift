//
//  File.swift
//  
//
//  Created by hujinyou on 2024/5/27.
//

import SwiftUI

public protocol DisplayLabelProtocol: CaseIterable, Identifiable, Hashable {
    var label: String { get }
    var image: String? { get }
    var systemImage: String? { get }
}

public extension DisplayLabelProtocol {
    var image: String? { nil }
    var systemImage: String? { nil }
}

public extension DisplayLabelProtocol {
    @ViewBuilder
    func makeDisplayLabel() -> some View {
        if let image {
            Label(label, image: image)
        } else if let systemImage {
            Label(label, systemImage: systemImage)
        } else {
            Text(label)
        }
    }
}

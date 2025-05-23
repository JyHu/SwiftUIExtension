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
            HStack {
                Image(image)
                Text(label)
            }
        } else if let systemImage {
            HStack {
                Image(systemName: systemImage)
                Text(label)
            }
        } else {
            Text(label)
        }
    }
}

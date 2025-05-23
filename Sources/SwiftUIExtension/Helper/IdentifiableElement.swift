//
//  IdentifiableElement.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/5/10.
//

import SwiftUI

extension Int: @retroactive Identifiable {
    public var id: Int { self }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/12.
//

import SwiftUI

/// 用于存入AppStorage
/// https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e
extension Color: RawRepresentable {
    public init?(rawValue: String) {
        do {
            if let data = Data(base64Encoded: rawValue),
               let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSUIColor.self, from: data) {
                self = Color(color)
            } else {
                self = .black
            }
        } catch {
            self = .black
        }
    }

    public var rawValue: String {
        do {
            if #available(iOS 14.0, *) {
                return (try NSKeyedArchiver.archivedData(withRootObject: NSUIColor(self), requiringSecureCoding: false) as Data).base64EncodedString()
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
}

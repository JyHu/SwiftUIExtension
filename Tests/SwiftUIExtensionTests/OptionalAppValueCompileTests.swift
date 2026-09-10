import XCTest
@testable import SwiftUIExtension
import SwiftUI

/// 编译期验证：@AppValue 能持有 Date? 等可选类型（RawRepresentable & Codable）
final class OptionalAppValueCompileTests: XCTestCase {
    @AppValue(DefaultAppValue<Date?>(key: "compile.date", default: nil)) private var lastSyncDate: Date?
    @AppValue(DefaultAppValue<String?>(key: "compile.str", default: nil)) private var str: String?

    func testCompilesWithOptionalTypes() {
        // 仅验证属性包装器能编译并通过 wrappedValue/projectedValue 访问
        _ = lastSyncDate
        _ = $lastSyncDate
        _ = str
        _ = $str
        // 赋值与置 nil 均需可编译
        lastSyncDate = Date()
        lastSyncDate = nil
        str = "hello"
        str = nil
        XCTAssertTrue(true)
    }
}

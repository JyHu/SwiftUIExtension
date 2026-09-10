import XCTest
@testable import SwiftUIExtension
import SwiftUI

final class OptionalAppValueTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "OptionalAppValueTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    // MARK: - RawRepresentable 层（AppStorage 实际依赖的机制）

    func testOptionalRawRepresentableRoundTrip() {
        let d: Date? = Date(timeIntervalSince1970: 1_700_000_000)
        let raw = d.rawValue
        XCTAssertFalse(raw.isEmpty)
        XCTAssertEqual(Date?(rawValue: raw), d)
    }

    func testNilRawRepresentableIsEmpty() {
        let n: Date? = nil
        XCTAssertTrue(n.rawValue.isEmpty)
        XCTAssertNil(Date?(rawValue: ""))
    }

    func testNonNilStringRoundTrip() {
        let s: String? = "hello"
        let raw = s.rawValue
        XCTAssertFalse(raw.isEmpty)
        XCTAssertEqual(String?(rawValue: raw), s)
    }

    // MARK: - AppStorage 存储语义（用 UserDefaults 模拟 @AppStorage 的持久化）

    func testDateStoredInDefaults() {
        // @AppStorage 存的是 Optional 的 rawValue（JSON 字符串）
        let d: Date? = Date(timeIntervalSince1970: 1_700_000_000)
        defaults.set(d.rawValue, forKey: "optDate")
        let stored = defaults.string(forKey: "optDate")
        XCTAssertEqual(Date?(rawValue: stored ?? ""), d)
    }

    func testNilStoredAsEmptyString() {
        let n: Date? = nil
        defaults.set(n.rawValue, forKey: "optDate")
        let stored = defaults.string(forKey: "optDate")
        XCTAssertEqual(stored, "")
        XCTAssertNil(Date?(rawValue: stored ?? ""))
    }

    func testMissingKeyDefaultsToNil() {
        XCTAssertNil(defaults.string(forKey: "missing"))
        // AppStorage 缺失 key → 用 default（nil）→ 还原 nil
        XCTAssertNil(Date?(rawValue: ""))
    }
}

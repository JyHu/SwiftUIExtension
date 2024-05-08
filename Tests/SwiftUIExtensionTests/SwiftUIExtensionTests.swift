import XCTest
@testable import SwiftUIExtension
import SwiftUI

final class SwiftUIExtensionTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftUIExtension().text, "Hello, World!")
        let view = Text("").randomBackground
    }
}

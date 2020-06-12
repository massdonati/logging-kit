import XCTest
import Logging
@testable import LoggingKit

final class MetadataTests: XCTestCase {
    func testExample() {
        var meta1: Logger.Metadata = ["ciccio": .string("ciccio")]
        let meta2: Logger.Metadata = ["ciccio1": .string("ciccio")]

        XCTAssertEqual(meta1.keys.count, 1)
        meta1 += meta2
        XCTAssertEqual(meta1.keys.count, 2)
    }

    func testExample2() {
        var meta1: Logger.Metadata = ["ciccio": .string("ciccio")]
        let meta2: Logger.Metadata? = nil

        XCTAssertEqual(meta1.keys.count, 1)
        meta1 += meta2
        XCTAssertEqual(meta1.keys.count, 1)
    }
    static var allTests = [
        ("testExample", testExample),
        ("testExample2", testExample2)
    ]
}

//
//  MetadataTests.swift
//
//
//  Created by Massimo Donati on 6/20/20.
//
import XCTest
import Logging
@testable import LoggingKit

final class MetadataTests: XCTestCase {
    func testCombiningMetadata1() {
        var meta1: Logger.Metadata = ["ciccio": .string("ciccio")]
        let meta2: Logger.Metadata = ["ciccio1": .string("ciccio")]

        XCTAssertEqual(meta1.keys.count, 1)
        meta1 += meta2
        XCTAssertEqual(meta1.keys.count, 2)
    }

    func testCombiningMetadata2() {
        var meta1: Logger.Metadata = ["ciccio": .string("ciccio")]
        let meta2: Logger.Metadata? = nil

        XCTAssertEqual(meta1.keys.count, 1)
        meta1 += meta2
        XCTAssertEqual(meta1.keys.count, 1)
    }
    static var allTests = [
        ("testCombiningMetadata1", testCombiningMetadata1),
        ("testCombiningMetadata2", testCombiningMetadata2)
    ]
}

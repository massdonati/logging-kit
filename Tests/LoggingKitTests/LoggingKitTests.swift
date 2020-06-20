//
//  LoggingKitTests.swift
//
//
//  Created by Massimo Donati on 6/20/20.
//
import XCTest
import Logging
@testable import LoggingKit

final class LoggingKitTests: XCTestCase {
    func testMetadataStringConvertible() {
        let metaValue: Logger.MetadataValue = .stringConvertible(StringConvertibleMockEnum.one)
        XCTAssertNotNil(metaValue.toJsonObject() as? String, "it should be converted to a string")
        let strValue = metaValue.toJsonObject() as! String
        XCTAssertEqual(strValue, "one")
    }
}

enum StringConvertibleMockEnum: CustomStringConvertible {
    case one
    var description: String {
        "one"
    }
}

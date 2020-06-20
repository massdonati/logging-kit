//
//  StringFormatterTests+XCTest.swift
//
//
//  Created by Massimo Donati on 6/20/20.
//
import XCTest

extension StringFormatterTests {
    static var allTests: [(String, (StringFormatterTests) -> () throws -> Void)] {
        return [
            ("testDefaultFormatString", testDefaultFormatString),
            ("testDefaultFormatStringMissingThread", testDefaultFormatStringMissingThread),
            ("testDefaultDateFormatterFormat", testDefaultDateFormatterFormat),
            ("testDateOnly", testDateOnly),
            ("testHandlerOnly", testHandlerOnly),
            ("testThreadNameOnly", testThreadNameOnly),
            ("testLevelNameOnly", testLevelNameOnly),
            ("testLevelSymbolOnly", testLevelSymbolOnly),
            ("testFileNameOnly", testFileNameOnly),
            ("testFunctionNameOnly", testFunctionNameOnly),
            ("testLineNumberOnly", testLineNumberOnly),
            ("testMessageOnly", testMessageOnly),
            ("testMetadataOnly", testMetadataOnly),
        ]
    }
}

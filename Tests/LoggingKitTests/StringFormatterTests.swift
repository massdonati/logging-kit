//
//  File.swift
//  
//
//  Created by Massimo Donati on 6/20/20.
//

import Foundation
import XCTest
import Logging
@testable import LoggingKit

class StringFormatterTests: XCTestCase {

    func testDefaultFormatString() {
        let mapper = StringLogMapper()
        XCTAssertEqual(mapper.logFormat, "[d] [h] t s F:# f - m\nM")
        let date = Date()
        let log = Log.fixture(
            handler: "h.id",
            level: .info,
            date: date,
            message: "message",
            thread: "thread",
            function: "function",
            file: "file",
            line: 27,
            metadata: ["user_id": .string("123")]
        )

        let formattedString = mapper.map(log)
        let expectedString = """
            [\(String(describing:date))] [h.id] thread 🔷 file:27 function - message
            {
              "user_id" : "123"
            }
            """

        XCTAssertEqual(formattedString, expectedString)
    }

    func testDefaultFormatStringMissingThread() {
        let mapper = StringLogMapper()
        XCTAssertEqual(mapper.logFormat, "[d] [h] t s F:# f - m\nM")
        let date = Date()
        let log = Log.fixture(
            handler: "h.id",
            level: .info,
            date: date,
            message: "message",
            function: "function",
            file: "file",
            line: 27,
            metadata: ["user_id": .string("123")]
        )

        let formattedString = mapper.map(log)

        // the symble `t` will be replaced with an empty string leaving
        // two consecutive spaces
        let expectedString = """
            [\(String(describing:date))] [h.id]  🔷 file:27 function - message
            {
              "user_id" : "123"
            }
            """

        XCTAssertEqual(formattedString, expectedString)
    }

    func testDefaultDateFormatterFormat() {
        let mapper = StringLogMapper()
        XCTAssertNil(mapper.dateFormatter)
        XCTAssertEqual(mapper.writingOption, .prettyPrinted)
    }


    func testDateOnly() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        var mapper = StringLogMapper(with: "d", dateFormatter: dateFormatter)
        let date = Date()
        let log = Log.fixture(date: date)
        let stringDate = mapper.dateFormatter!.string(from: date)
        let outString = mapper.map(log)
        XCTAssertEqual(stringDate, outString)

        // test additional text

        mapper = StringLogMapper(with: "[d]", dateFormatter: dateFormatter)
        let outStringTwo = mapper.map(log)
        XCTAssertEqual("[\(stringDate)]", outStringTwo)
    }

    func testHandlerOnly() {
        var mapper = StringLogMapper(with: "h")
        let handlerId = "com.tambo.logger"
        let log = Log.fixture(handler: handlerId)

        let outString = mapper.map(log)
        XCTAssertEqual(handlerId, outString)

        // test additional text

        mapper = StringLogMapper(with: "[h]")
        let outStringTwo = mapper.map(log)
        XCTAssertEqual("[\(handlerId)]", outStringTwo)
    }

    func testThreadNameOnly() {
        var mapper = StringLogMapper(with: "t")
        let threadName = "main"
        let log = Log.fixture(thread: threadName)

        let outString = mapper.map(log)
        XCTAssertEqual(threadName, outString)

        // test additional text

        mapper = StringLogMapper(with: "[t]")
        let outStringTwo = mapper.map(log)
        XCTAssertEqual("[\(threadName)]", outStringTwo)
    }

    func testLevelNameOnly() {
        let levels = Logger.Level.allCases
        levels.forEach { level in
            var mapper = StringLogMapper(with: "l")

            let log = Log.fixture(level: level)

            let outString = mapper.map(log)
            XCTAssertEqual(level.rawValue, outString)

            // test additional text

            mapper = StringLogMapper(with: "[l]")
            let outStringTwo = mapper.map(log)
            XCTAssertEqual("[\(level.rawValue)]", outStringTwo)
        }
    }

    func testLevelSymbolOnly() {
        let levels = Logger.Level.allCases
        levels.forEach { level in
            var mapper = StringLogMapper(with: "s")

            let log = Log.fixture(level: level)

            let outString = mapper.map(log)
            XCTAssertEqual(level.symbol, outString)

            // test additional text

            mapper = StringLogMapper(with: "[s]")
            let outStringTwo = mapper.map(log)
            XCTAssertEqual("[\(level.symbol)]", outStringTwo)
        }
    }

    func testFileNameOnly() {
        let fileName = "TamboViewController"
        let filePath = "/proj/\(fileName).swift"
        var mapper = StringLogMapper(with: "F")

        let log = Log.fixture(file: filePath)

        let outString = mapper.map(log)
        XCTAssertEqual(fileName, outString)

        // test additional text

        mapper = StringLogMapper(with: "[F]")
        let outStringTwo = mapper.map(log)
        XCTAssertEqual("[\(fileName)]", outStringTwo)
    }

    func testFunctionNameOnly() {
        let functionName = "viewDidLoad()"
        var mapper = StringLogMapper(with: "f")

        let log = Log.fixture(function: functionName)

        let outString = mapper.map(log)
        XCTAssertEqual(functionName, outString)

        // test additional text

        mapper = StringLogMapper(with: "[f]")
        let outStringTwo = mapper.map(log)
        XCTAssertEqual("[\(functionName)]", outStringTwo)
    }

    func testLineNumberOnly() {
        let lineNumber: UInt = 24
        var mapper = StringLogMapper(with: "#")

        let log = Log.fixture(line: lineNumber)

        let outString = mapper.map(log)
        XCTAssertEqual("\(lineNumber)", outString)

        // test additional text

        mapper = StringLogMapper(with: "[#]")
        let outStringTwo = mapper.map(log)
        XCTAssertEqual("[\(lineNumber)]", outStringTwo)
    }

    func testMessageOnly() {
        var mapper = StringLogMapper(with: "m")

        let log = Log.fixture(message: "some info message")

        let outString = mapper.map(log)
        XCTAssertEqual("some info message", outString)

        // test additional text

        mapper = StringLogMapper(with: "[m]")
        let outStringTwo = mapper.map(log)
        XCTAssertEqual("[\("some info message")]", outStringTwo)
    }

    func testMetadataOnly() {
        let metadata: Logger.Metadata = ["one": .stringConvertible(2)]
        let expectedString = """
        {
          "one" : 2
        }
        """

        var mapper = StringLogMapper(with: "M")

        let log = Log.fixture(metadata: metadata)

        let outString = mapper.map(log)

        XCTAssertEqual(expectedString, outString)

        // test additional text

        mapper = StringLogMapper(with: "[M]")
        let outStringTwo = mapper.map(log)
        XCTAssertEqual("[\(expectedString)]", outStringTwo)
    }

    static var allTests = [
        ("testDefaultFormatString", testDefaultFormatString),
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
        ("testMetadataOnly", testMetadataOnly)
    ]
}

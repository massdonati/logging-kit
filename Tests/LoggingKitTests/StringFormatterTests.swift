//
//  StringFormatterTests.swift
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
        let formatter = DefaultStringFormatter()
        XCTAssertEqual(formatter.logFormat, "[d] [h] t s F:# f - m\nM")
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

        let formattedString = formatter.string(from: log)
        let expectedString = """
            [\(String(describing:date))] [h.id] thread 🔷 file:27 function - message
            {
              "user_id" : "123"
            }
            """

        XCTAssertEqual(formattedString, expectedString)
    }

    func testDefaultFormatStringMissingThread() {
        let formatter = DefaultStringFormatter()
        XCTAssertEqual(formatter.logFormat, "[d] [h] t s F:# f - m\nM")
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

        let formattedString = formatter.string(from: log)

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
        let formatter = DefaultStringFormatter()
        XCTAssertNil(formatter.dateFormatter)
        XCTAssertEqual(formatter.writingOption, .prettyPrinted)
    }


    func testDateOnly() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        var formatter = DefaultStringFormatter(with: "d", dateFormatter: dateFormatter)
        let date = Date()
        let log = Log.fixture(date: date)
        let stringDate = formatter.dateFormatter!.string(from: date)
        let outString = formatter.string(from: log)
        XCTAssertEqual(stringDate, outString)

        // test additional text

        formatter = DefaultStringFormatter(with: "[d]", dateFormatter: dateFormatter)
        let outStringTwo = formatter.string(from: log)
        XCTAssertEqual("[\(stringDate)]", outStringTwo)
    }

    func testHandlerOnly() {
        var formatter = DefaultStringFormatter(with: "h")
        let handlerId = "com.tambo.logger"
        let log = Log.fixture(handler: handlerId)

        let outString = formatter.string(from: log)
        XCTAssertEqual(handlerId, outString)

        // test additional text

        formatter = DefaultStringFormatter(with: "[h]")
        let outStringTwo = formatter.string(from: log)
        XCTAssertEqual("[\(handlerId)]", outStringTwo)
    }

    func testThreadNameOnly() {
        var formatter = DefaultStringFormatter(with: "t")
        let threadName = "main"
        let log = Log.fixture(thread: threadName)

        let outString = formatter.string(from: log)
        XCTAssertEqual(threadName, outString)

        // test additional text

        formatter = DefaultStringFormatter(with: "[t]")
        let outStringTwo = formatter.string(from: log)
        XCTAssertEqual("[\(threadName)]", outStringTwo)
    }

    func testLevelNameOnly() {
        let levels = Logger.Level.allCases
        levels.forEach { level in
            var formatter = DefaultStringFormatter(with: "l")

            let log = Log.fixture(level: level)

            let outString = formatter.string(from: log)
            XCTAssertEqual(level.rawValue, outString)

            // test additional text

            formatter = DefaultStringFormatter(with: "[l]")
            let outStringTwo = formatter.string(from: log)
            XCTAssertEqual("[\(level.rawValue)]", outStringTwo)
        }
    }

    func testLevelSymbolOnly() {
        let levels = Logger.Level.allCases
        levels.forEach { level in
            var formatter = DefaultStringFormatter(with: "s")

            let log = Log.fixture(level: level)

            let outString = formatter.string(from: log)
            XCTAssertEqual(level.symbol, outString)

            // test additional text

            formatter = DefaultStringFormatter(with: "[s]")
            let outStringTwo = formatter.string(from: log)
            XCTAssertEqual("[\(level.symbol)]", outStringTwo)
        }
    }

    func testFileNameOnly() {
        let fileName = "TamboViewController"
        let filePath = "/proj/\(fileName).swift"
        var formatter = DefaultStringFormatter(with: "F")

        let log = Log.fixture(file: filePath)

        let outString = formatter.string(from: log)
        XCTAssertEqual(fileName, outString)

        // test additional text

        formatter = DefaultStringFormatter(with: "[F]")
        let outStringTwo = formatter.string(from: log)
        XCTAssertEqual("[\(fileName)]", outStringTwo)
    }

    func testFunctionNameOnly() {
        let functionName = "viewDidLoad()"
        var formatter = DefaultStringFormatter(with: "f")

        let log = Log.fixture(function: functionName)

        let outString = formatter.string(from: log)
        XCTAssertEqual(functionName, outString)

        // test additional text

        formatter = DefaultStringFormatter(with: "[f]")
        let outStringTwo = formatter.string(from: log)
        XCTAssertEqual("[\(functionName)]", outStringTwo)
    }

    func testLineNumberOnly() {
        let lineNumber: UInt = 24
        var formatter = DefaultStringFormatter(with: "#")

        let log = Log.fixture(line: lineNumber)

        let outString = formatter.string(from: log)
        XCTAssertEqual("\(lineNumber)", outString)

        // test additional text

        formatter = DefaultStringFormatter(with: "[#]")
        let outStringTwo = formatter.string(from: log)
        XCTAssertEqual("[\(lineNumber)]", outStringTwo)
    }

    func testMessageOnly() {
        var formatter = DefaultStringFormatter(with: "m")

        let log = Log.fixture(message: "some info message")

        let outString = formatter.string(from: log)
        XCTAssertEqual("some info message", outString)

        // test additional text

        formatter = DefaultStringFormatter(with: "[m]")
        let outStringTwo = formatter.string(from: log)
        XCTAssertEqual("[\("some info message")]", outStringTwo)
    }

    func testMetadataOnly() {
        let metadata: Logger.Metadata = ["one": .stringConvertible(2)]
        let expectedString = """
        {
          "one" : 2
        }
        """

        var formatter = DefaultStringFormatter(with: "M")

        let log = Log.fixture(metadata: metadata)

        let outString = formatter.string(from: log)

        XCTAssertEqual(expectedString, outString)

        // test additional text

        formatter = DefaultStringFormatter(with: "[M]")
        let outStringTwo = formatter.string(from: log)
        XCTAssertEqual("[\(expectedString)]", outStringTwo)
    }
}

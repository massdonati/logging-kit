//
//  LogHandlerTests.swift
//  
//
//  Created by Massimo Donati on 6/17/20.
//

import XCTest
import Logging
@testable import LoggingKit

final class LogHandlerTests: XCTestCase {
    func testAutoStreamConformace() {

        let handlerMock = HanlderMock()
        let expectation = XCTestExpectation(description: "wait for the log to be processed")
        handlerMock.logOutput = { level, message, metadata, file, function, line in
            XCTAssertEqual(level, .info)
            XCTAssertEqual(message, "some message")
            XCTAssertNotNil(metadata)
            XCTAssertEqual(metadata!.keys.count, 1)
            XCTAssertEqual(metadata!["one"], .string("two"))
            XCTAssertEqual(file, "someFile")
            XCTAssertEqual(function, "someFunction")
            XCTAssertEqual(line, 123)
            print(Date())
            expectation.fulfill()

        }

        XCTAssertEqual(handlerMock.dispatchingMode, .async)
        XCTAssertNotNil(UUID(uuidString: handlerMock.identifier))


        let log = Logger(label: "logger_id") { id in
            var tHandler = TamboLogHandler(identifier: id)
            tHandler.setStreams(streams: [handlerMock])
            return tHandler
        }
        log.info("some message", metadata: ["one": .string("two")], file: "someFile", function: "someFunction", line: 123)

        wait(for: [expectation], timeout: 2)
    }

    static var allTests = [
        ("testAutoStreamConformace", testAutoStreamConformace),
    ]
}

class HanlderMock: LogHandler, LoggingKit.LogStream {

    typealias LogOutput = (Logger.Level, Logger.Message, Logger.Metadata?, String, String, UInt) -> Void
    var logOutput: LogOutput?
    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {
        logOutput?(level, message, metadata, file, function, line)
    }

    subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }

    var metadata = Logger.Metadata()

    var logLevel: Logger.Level = .trace
}

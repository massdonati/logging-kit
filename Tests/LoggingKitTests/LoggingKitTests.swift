import XCTest
@testable import LoggingKit
import Logging
import Combine

@available(OSX 10.15, *)
final class LoggingKitTests: XCTestCase {

    func testCombineSubscription() {

        let log = Logger(label: "ciccio") { id in
            TamboHandler(identifier: id,
            streams: [Sub1(), Sub2()])
        }

        log.info("ciao a tutti")
    }

    static var allTests = [
        ("testCombineSubscription", testCombineSubscription)
    ]
}

@available(OSX 10.15, *)
class Sub1: StreamProtocol {
    var logFilter: LogFilterClosure?
    var cancellable: AnyCancellable?

    func subscribe(to logPublisher: AnyPublisher<Log, Never>) {
        cancellable = logPublisher
            .filter { $0.level >= .warning
        }
            .sink(receiveValue: { log in
                print("sub1- \(log.message)")
            })
    }

    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {

    }

    var metadata: Logger.Metadata = [:]

    var logLevel: Logger.Level = .info
}

@available(OSX 10.15, *)
class Sub2: StreamProtocol {
    var logFilter: LogFilterClosure?
    var cancellable: AnyCancellable?

    func subscribe(to logPublisher: AnyPublisher<Log, Never>) {
        cancellable = logPublisher.sink(receiveValue: { log in
            print("sub2- \(log.message)")
        })
    }

    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {

    }

    var metadata: Logger.Metadata = [:]

    var logLevel: Logger.Level = .info

}

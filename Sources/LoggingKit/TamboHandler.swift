import Foundation
import Logging

public struct TamboHandler: LogHandler {

    let identifier: String
    var streams: [StreamProtocol] = []
    public var metadata = Logger.Metadata()
    public var logLevel: Logger.Level = .trace

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file: String,
                    function: String,
                    line: UInt) {

        let log = Log(
            handlerIdentifier: identifier,
            level: level,
            date: Date(),
            message: message,
            thread: threadName(),
            function: function,
            file: file,
            line: line,
            logMetadata: metadata,
            handlerMetadata: self.metadata
        )
        streams
            .filter { !$0.should(filterOut: log) }
            .forEach { $0.process(log) }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }
}

import Foundation
import Logging
import Combine

@available(OSX 10.15, *)
public struct TamboHandler: LogHandler {

    let identifier: String
    let streams: [StreamProtocol]
    public var metadata = Logger.Metadata()
    public var logLevel: Logger.Level = .trace
    var logPublisher = PassthroughSubject<Log, Never>()

    init(identifier: String, streams: [StreamProtocol]) {
        assert(streams.isEmpty == false)
        self.identifier = identifier
        self.streams = streams

        logPublisher = PassthroughSubject<Log, Never>()
        streams.forEach { stream in
            stream.subscribe(
                to: logPublisher
                    .eraseToAnyPublisher()
            )
        }
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file: String,
                    function: String,
                    line: UInt) {

        guard level >= logLevel else { return }

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

        logPublisher.send(log)
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

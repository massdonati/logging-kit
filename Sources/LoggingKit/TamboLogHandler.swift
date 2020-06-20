//
//  TamboLogHandler.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation
import Logging

var log: Logger?

public enum LoggingKitSystem {
    public static func setDebug(_ debug: Bool) {
        log = debug ? Logger(label: "com.tambo.handler.debug.logger") : nil
    }
}

public struct TamboLogHandler: LogHandler {
    let queue = DispatchQueue(label: "com.tambo.handler.queue", qos: .utility)
    let identifier: String
    @Atomic var streams: [LogStream] = []
    @Atomic public var metadata = Logger.Metadata()
    public var logLevel: Logger.Level

    public init(identifier: String,
                logLevel: Logger.Level = .trace) {
        self.identifier = identifier
        self.logLevel = logLevel
        self.streams = [ConsoleLogStream(identifier: "com.tambo-handler.console")]
    }

    public init(identifier: String,
                logLevel: Logger.Level = .trace,
                streams: [LogStream]) {
        self.identifier = identifier
        self.logLevel = logLevel
        self.streams = streams
    }

    mutating public func add(stream: LogStream) {
        let duplicate = streams.contains { $0.identifier == stream.identifier }
        guard !duplicate else { return }
        streams.append(stream)
    }

    mutating public func add(streams: [LogStream]) {
        streams.forEach { self.add(stream: $0) }
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file: String,
                    function: String,
                    line: UInt) {

        let log = Log(
            handler: identifier,
            level: level,
            date: Date(),
            message: message,
            thread: threadName(),
            function: function,
            file: file,
            line: line,
            metadata: self.metadata.merge(metadata)
        )
        
        streams
            .filter { $0.level.allows(log.level) }
            .filter { !$0.should(filterOut: log) }
            .forEach { $0.dispatch(log, defaultQueue: queue) }
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


extension Logger.Metadata {
    static func +=(lhs: inout Logger.Metadata, rhs: Logger.Metadata?) {
        rhs?.compactMapValues { $0 }
            .forEach { key, value in
            lhs[key] = value
        }
    }
}

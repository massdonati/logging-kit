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
        log = debug ? Logger(label: "com.tambo-handler.debug-logger") : nil
    }
}

public struct TamboLogHandler: LogHandler {
    let queue = DispatchQueue(label: "com.tambo-handler.queue", qos: .utility)
    let identifier: String
    var streams: [LogStream] = []
    public var metadata = Logger.Metadata()
    public var logLevel: Logger.Level

    public init(identifier: String,
                logLevel: Logger.Level = .trace) {
        self.identifier = identifier
        self.logLevel = logLevel
        self.streams = [ConsoleLogStream(identifier: "com.tambo-handler.console")]
    }

    mutating public func add(stream: LogStream) {
        let duplicate = streams.contains { $0.identifier == stream.identifier }
        guard !duplicate else { return }
        streams.append(stream)
    }

    mutating public func setStreams(streams: [LogStream]) {
        self.streams = []
        streams.forEach { self.add(stream: $0) }
    }

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
            metadata: aggregateMetadata(with: metadata)
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

    func aggregateMetadata(with logMetadata: Logger.Metadata?) -> Logger.Metadata? {
        var logMeta = Logger.Metadata()
        if metadata.isEmpty == false {
            logMeta = [identifier: .dictionary(metadata)]
        }

        logMeta += logMetadata

        return logMeta.isEmpty ? nil : logMeta
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

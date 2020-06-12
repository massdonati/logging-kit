//
//  Log.swift
//  
//
//  Created by Massimo Donati on 6/12/20.
//

import Foundation
import Logging

public struct Log: Identifiable {

    /// identifier associated with this specific `Log` instance
    public var id = UUID().uuidString

    /// the Logger handler identifier this object was dispatched from.
    public let handlerIdentifier: String

    /// The level of the log i.e. `.info`.
    public let level: Logger.Level

    /// The time this log was originated at.
    public let date: Date

    /**
     The log message to display.
     - note: Since the message can be costly to compute, think about
        interpolated strings with array mappings, this is a closure so we can
        move that computation to a background thread that will alleviate
        the processing at the caller side.
     */
    public let message: Logger.Message

    /// Example: "com.apple.main-thread"
    /// - note: uses `__dispatch_queue_get_label` under the hood.
    public let thread: String?

    /// The name of the function that generated this log.
    public let function: String

    /// The full path of the file the log was generated from.
    public let file: String

    /// The line number that generated this log.
    public let line: UInt

    /// Dictionary to store useful metadata about the log.
    public var metadata: Logger.Metadata?
}

extension Log {

    public var fileName: String? {
        return filename(from: file)
    }

    func toDictionary() -> [String: Any] {

        var dict: [String: Any] = [
            "id": id,
            "handler_identifier": handlerIdentifier,
            "level": level,
            "date": date,
            "message": message.description,
            "function": function,
            "file": file,
            "line": line
        ]

        if let thread = thread {
            dict["thread"] = thread
        }
        if let name = fileName {
            dict ["file_name"] = name
        }
        if let meta = metadata?.toJsonObject() {
            dict ["metadata"] = meta
        }
        return dict
    }
}

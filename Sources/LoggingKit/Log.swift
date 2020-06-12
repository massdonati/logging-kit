//
//  File.swift
//  
//
//  Created by Massimo Donati on 6/12/20.
//

import Foundation
import Logging

public struct Log {

    /// the Logger identifier this object was originated from.
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

    /// "com.apple.main-thread"
    public let thread: String?

    /// The name of the function that generated this log.
    public let function: String

    /// The full path of the file the log was generated from.
    public let file: String

    /// The line number that generated this log.
    public let line: UInt

    /// Dictionary to store useful metadata about the log.
    public var logMetadata: Logger.Metadata?

    public var handlerMetadata: Logger.Metadata?
}


//
//  File.swift
//  
//
//  Created by Massimo Donati on 6/20/20.
//

import Foundation
import Logging
@testable import LoggingKit

extension Log {
    static func fixture(handler: String = "handler_id",
                        level: Logger.Level = .info,
                        date: Date = Date(),
                        message: Logger.Message = "message",
                        thread: String? = nil,
                        function: String = "function",
                        file: String = "file",
                        line: UInt = 1,
                        metadata: Logger.Metadata? = nil) -> Log {
        return Log(
            handler: handler,
            level: level,
            date: date,
            message: message,
            thread: thread,
            function: function,
            file: file,
            line: line,
            metadata: metadata
        )
    }
}

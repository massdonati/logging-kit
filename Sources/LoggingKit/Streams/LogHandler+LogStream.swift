//
//  LogHandler+LogStream.swift
//  
//
//  Created by Massimo Donati on 6/17/20.
//

import Foundation
import Logging

public extension LogStream where Self: LogHandler {
    var identifier: String { UUID().uuidString }
    var level: Level { return .higherThen(logLevel) }
    var dispatchingMode: DispatchingMode { .async }

    func process(_ log: Log) {
        self.log(level: log.level,
                 message: log.message,
                 metadata: log.metadata,
                 file: log.file,
                 function: log.function,
                 line: log.line)
    }
}

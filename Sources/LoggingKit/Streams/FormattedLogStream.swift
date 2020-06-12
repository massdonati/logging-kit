//
//  FormattedLogStream.swift
//  
//
//  Created by Massimo Donati on 6/16/20.
//

import Foundation

public protocol FormattedLogStream: LogStream {
    associatedtype Formatter: LogFormatter
    var formatter: Formatter {get}

    func output(original log: Log, formattedLog: Result<Formatter.Output, Error>)

}

public extension FormattedLogStream {
    func process(_ log: Log) {
        let formattedLog = formatter.format(log)
        output(original: log, formattedLog: formattedLog)
    }
}

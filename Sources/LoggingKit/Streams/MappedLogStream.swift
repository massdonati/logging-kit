//
//  FormattedLogStream.swift
//  
//
//  Created by Massimo Donati on 6/16/20.
//

import Foundation

public protocol MappedLogStream: LogStream {
    associatedtype Mapper: LogMapper
    var mapper: Mapper {get}

    func output(original log: Log, result: Mapper.Output)
}

public extension MappedLogStream {
    func process(_ log: Log) {
        let result = mapper.map(log)
        output(original: log, result: result)
    }
}

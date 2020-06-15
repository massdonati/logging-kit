//
//  File.swift
//  
//
//  Created by Massimo Donati on 6/12/20.
//

import Foundation
import Logging
import Combine
/**
 A closure that will determine if a `Log` should be filtered or not.
 - parameter log: The Log instance to be evaluated.
 - returns: true if the `Log` should be discarded, false otherwise.
 */
@available(OSX 10.15, *)
public typealias LogFilterClosure = (_ log: Log) -> Bool

@available(OSX 10.15, *)
public protocol StreamProtocol {
    var metadata: Logger.Metadata { get set }

    var logLevel: Logger.Level { get set }

    var logFilter: LogFilterClosure? {get}

    func subscribe(to logPublisher: AnyPublisher<Log, Never>)
}

@available(OSX 10.15, *)
extension StreamProtocol {
    func should(filterOut log: Log) -> Bool {
        logLevel <= log.level
            && logFilter != nil
            && logFilter?(log) == true
    }
}

extension LogHandler {
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }
}

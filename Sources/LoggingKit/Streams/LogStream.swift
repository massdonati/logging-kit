//
//  LogStream.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation
import Logging
/**
 A closure that will determine if a `Log` should be filtered or not.
 - parameter log: The Log instance to be evaluated.
 - returns: true if the `Log` should be discarded, false otherwise.
 */
public typealias LogFilterClosure = (_ log: Log) -> Bool

public enum DispatchingMode: Equatable {
    case sync, async, asyncWithQueue(DispatchQueue)
}

public protocol LogStream {
    var identifier: String {get}
    var dispatchingMode: DispatchingMode {get}
    var level: Level {get}
    var metadata: Logger.Metadata {get}
    func process(_ log: Log)
    func should(filterOut log: Log) -> Bool
}

extension LogStream {
    public func should(filterOut log: Log) -> Bool { return false }
    
    func dispatch(_ log: Log, defaultQueue: DispatchQueue) {
        let block = { self.process(log) }
        switch dispatchingMode {
        case .sync:
            block()
        case .async:
            defaultQueue.async(execute: block)
        case .asyncWithQueue(let streamQueue):
            streamQueue.async(execute: block)
        }
    }
}

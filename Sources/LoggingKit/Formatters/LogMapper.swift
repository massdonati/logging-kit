//
//  LogFormatter.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation

/**
 A LogFormatter is used to map a `Log` instance into an `Output` type.

 It is designed to be part by the `FormattedLogStream` definition and it will define what would be the
 Output type of the stream it self.
 */
public protocol LogMapper {

    /// The type the formtter will map the Log instance into
    associatedtype Output

    /**
     Maps a Log instance into the `Output`
     - parameter log: a log instance
     - returns: the result of the mapping
     */
    func map(_ log: Log) -> Output
}

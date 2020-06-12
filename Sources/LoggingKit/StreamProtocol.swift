//
//  File.swift
//  
//
//  Created by Massimo Donati on 6/12/20.
//

import Foundation
import Logging
/**
 A closure that will determine if a `Log` should be filtered or not.
 - parameter log: The Log instance to be evaluated.
 - returns: true if the `Log` should be discarded, false otherwise.
 */
public typealias LogFilterClosure = (_ log: Log) -> Bool

public protocol StreamProtocol: LogHandler {

    /**
     Array of filters that will be used to check if a `Log` instance
     should be discarded or not.
     */
    var logFilter: LogFilterClosure? {get}

    /**
     Process the log details.
     - parameter logDetails: Structure with all of the details for the log to
        process.
     - note: this is called by the logger whenever it receive a log from the
        client.
    */
    func process(_ log: Log)
}

extension StreamProtocol {
    func should(filterOut log: Log) -> Bool {
        logLevel <= log.level
            && logFilter != nil
            && logFilter?(log) == true
    }
}


//
//  VoidLogStream.swift
//  
//
//  Created by Massimo Donati on 6/17/20.
//

import Foundation
import Logging

public final class VoidLogStream: LogStream {
    public var identifier: String = "com.tambo.void-stream"
    public var dispatchingMode: DispatchingMode = .sync
    public var level: Level = .all
    public var metadata = Logger.Metadata()

    public init(identifier: String, level: Level =  .all) {
        self.identifier = identifier
        self.level = level
    }

    public func process(_ log: Log) {}
}

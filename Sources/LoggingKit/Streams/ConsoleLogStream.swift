//
//  ConsoleLogStream.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation
import Logging

/// The Xcode console stream. It will output the logs to the Xcode console.
public class ConsoleLogStream: MappedLogStream {
    public let identifier: String
    public let dispatchingMode: DispatchingMode
    public let level: Level
    @Atomic var _metadata: Logger.Metadata
    public var metadata: Logger.Metadata {
        get{
            _metadata
        }
        set(newValue) {
            _metadata = newValue
        }
    }
    public let mapper: StringLogMapper

    public init(identifier: String,
                dispatchingMode: DispatchingMode = .async,
                level: Level = .all,
                metadata: Logger.Metadata = .init(),
                formatter: StringLogMapper = .init()) {
        self.identifier = identifier
        self.dispatchingMode = dispatchingMode
        self.level = level
        self._metadata = metadata
        self.mapper = formatter
    }

    public func output(original log: Log, result: String) {
        print(result.description)
    }
}

extension Swift.Result where Success: CustomStringConvertible {
    var description: String {
        switch self {
        case .success(let string):
            return string.description
        case .failure(let error):
            return error.localizedDescription
        }
    }
}

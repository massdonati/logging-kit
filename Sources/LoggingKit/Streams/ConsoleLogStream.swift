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

    public enum OutputMode {
        case print
        case stdout
    }

    deinit {
        try? stdOut.close()
    }
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
    let outputMode: OutputMode
    public let mapper: StringLogMapper
    let stdOut = FileHandle.standardOutput

    public init(identifier: String,
                outputMode: OutputMode = .print,
                dispatchingMode: DispatchingMode = .async,
                level: Level = .all,
                metadata: Logger.Metadata = .init(),
                formatter: StringLogMapper = .init()) {
        self.identifier = identifier
        self.outputMode = outputMode
        self.dispatchingMode = dispatchingMode
        self.level = level
        self._metadata = metadata
        self.mapper = formatter
    }

    public func output(original log: Log, result: String) {
        switch outputMode {
        case .print:
            print(result)
        case .stdout:
            result.data(using: .utf8).flatMap { stdOut.write($0)}
        }
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

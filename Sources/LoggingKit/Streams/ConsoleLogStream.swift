//
//  ConsoleLogStream.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation
import Logging

/// The Xcode console stream. It will output the logs to the Xcode console.
public class ConsoleLogStream: FormattedLogStream {
    public let identifier: String
    public let dispatchingMode: DispatchingMode
    public let level: Level
    public var metadata: Logger.Metadata
    public let formatter = StringLogFormatter()

    public init(identifier: String,
                dispatchingMode: DispatchingMode = .async,
                level: Level = .all,
                metadata: Logger.Metadata = .init()) {
        self.identifier = identifier
        self.dispatchingMode = dispatchingMode
        self.level = level
        self.metadata = metadata
    }

    public func output(original log: Log, formattedLog: Result<String, Error>) {
        print(formattedLog.printableString)
    }
}

extension Swift.Result where Success: CustomStringConvertible {
    var printableString: String {
        switch self {
        case .success(let string):
            return string.description
        case .failure(let error):
            return error.localizedDescription
        }
    }
}

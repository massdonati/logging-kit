//
//  StringLogFormatter.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation

public final class StringLogMapper: LogMapper {

    var formatter: StringFormatter

    /// Designated initializer.
    public init(customStringFormatter: StringFormatter? = nil) {
        self.formatter = customStringFormatter ?? DefaultStringFormatter()
    }


    public init(with format: String? = nil,
                writingOption: JSONSerialization.WritingOptions? = nil,
                dateFormatter: DateFormatter? = nil) {
        self.formatter = DefaultStringFormatter(
            with: format,
            writingOption: writingOption,
            dateFormatter: dateFormatter
        )
    }

    public func map(_ log: Log) -> String  {
        return formatter.string(from: log)
    }
}


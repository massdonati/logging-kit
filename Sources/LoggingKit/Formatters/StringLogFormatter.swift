//
//  StringLogFormatter.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation

public final class StringLogFormatter: LogFormatter {
    enum Constants {
        static let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "HH:mm:ss.SSS"
            return df
        }()

        static let defaultFormat = """
            [D] [L] T S F:# f - M
            C
            """

    }

    public var logFormat: String

    /**
     The date formatter to be used to produce the string value.
     - note: The default one will format the date using `"HH:mm:ss.SSS"`
     */
    let dateFormatter: DateFormatter

    /// Designated initializer.
    public init(with format: String? = nil,
                dateFormatter: DateFormatter? = nil) {
        self.logFormat = format ?? Constants.defaultFormat
        self.dateFormatter = dateFormatter ?? Constants.dateFormatter
    }

    /**
     Produces a string from a [Log](x-source-tag://T.Log) object.
     - parameter log: The Log object we want to convert into a string.
     - seealso: [LogToStringFormatterProtocol](x-source-tag://T.LogToStringFormatterProtocol)
     */
    public func format(_ log: Log) -> Result<String, Error>  {
        var outputString = ""

        logFormat.forEach { ch in
            switch ch {
            case LogFormatKey.date.rawValue:
                outputString += dateFormatter.string(from: log.date)
            case LogFormatKey.logger.rawValue:
                outputString += log.handlerIdentifier
            case LogFormatKey.level.rawValue:
                outputString += log.level.rawValue
            case LogFormatKey.levelSymbol.rawValue:
                outputString += log.level.symbol
            case LogFormatKey.message.rawValue:
                outputString += log.message.description
            case LogFormatKey.thread.rawValue:
                outputString += log.thread ?? ""
            case LogFormatKey.function.rawValue:
                outputString += log.function
            case LogFormatKey.file.rawValue:
                outputString += log.file
            case LogFormatKey.line.rawValue:
                outputString += "\(log.line)"
            case LogFormatKey.context.rawValue:
                if let metadata = log.metadata {
                    outputString += metadata.toJSONString() ?? ""
                }
            default:
                outputString += String(ch)
            }
        }
        let cleanedOutput = outputString
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "  ", with: " ")

        return .success(cleanedOutput)
    }
}

/**
 Defines all the possible keys supported by
 [TLogToStringFormatterProtocol](x-source-tag://T.TLogToStringFormatterProtocol).
 */
enum LogFormatKey: Character {

    /// The time the [TLog](x-source-tag://T.TLog) was originated at.
    case date = "D"

    /// The logger identifier the [TLog](x-source-tag://T.TLog) was originated from.
    case logger = "L"

    /// The level name i.e. "info"
    case level = "l"

    /// The level symbol of the [TLog](x-source-tag://T.TLog) i.e. "ℹ️"
    case levelSymbol = "S"

    /// The [TLog](x-source-tag://T.TLog)'s message.
    case message = "M"

    /**
     The thread name the [Log](x-source-tag://T.Log) was originate from.
     The possible values are:
        1. "main_thread"
        2. the thread name
        3. the string descritpion of the thread
     */
    case thread = "T"

    /// The function name the [TLog](x-source-tag://T.TLog) was originated from.
    case function = "f"

    /**
     The file name the [Log](x-source-tag://T.Log) was originated
     from i.e. `MyFile`
     - note: this doesn't include the file extension.
     */
    case file = "F"

    /// The line number the [TLog](x-source-tag://T.TLog) was originated from.
    case line = "#"

    /// Any additional metadata useful to give more context to the logs.
    case context = "C"
}

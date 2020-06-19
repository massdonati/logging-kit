//
//  StringLogFormatter.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation

/**
 Formats a `Log` instance into a string.

 The `StringLogFormatter` works as follows:
 Each `LogInfoKey` stands for a specific piece of information of the `Log` instance, the formatting logic
 will replace only and exclusively the characters that are recognized with the information in the `Log` instance
 leaving all other characters in the same relative position.
 - Example:
 ```
 let format = """
    [D] [H] T L F:# f - m
    M
    """
 log.info("log message", metadata: ["user_id": .string("123")])
 ```
 would print the following information
 ```
 [22:52:29.843] [com.app.logger] com.queue.name INFO /path/to/file.swift:123 function() - log message
 {
  "user_id": "123"
 }
 ```
 This behavior is customizable in the order the information is placed, which information to display per log
 message and which formatting to give to the date and the metadata.
 For instance, for a format string like this one
 ```
 let format = "F::# - L - m"
 ```
 and a log message like this one
 ```
 log.info("log message", metadata: ["user_id": .string("123")])
 ```
 the string that will be print out would be this one
 ```
 File.swift::40 - INFO - log message
 ```
  */
public final class StringLogMapper: LogMapper {

    public typealias FormatString = String

    enum Constants {
        static let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "HH:mm:ss.SSS"
            return df
        }()

        static let defaultFormat = """
            [D] [H] T S F:# f - m
            M
            """
    }

    /// string used to format the information to display in each output string for each log instance
    public let logFormat: String

    /// writing options used to format the metdata information
    public let writingOption: JSONSerialization.WritingOptions

    /**
     The date formatter to be used to produce the string value.
     - note: The default one will format the date using `"HH:mm:ss.SSS"`
     */
    public let dateFormatter: DateFormatter

    /// Designated initializer.
    public init(with format: FormatString? = nil,
                writingOption: JSONSerialization.WritingOptions = .prettyPrinted,
                dateFormatter: DateFormatter? = nil) {
        self.logFormat = format ?? Constants.defaultFormat
        self.dateFormatter = dateFormatter ?? Constants.dateFormatter
        self.writingOption = writingOption
    }

    public func map(_ log: Log) -> Result<String, Error>  {
        var outputString = ""

        logFormat.forEach { ch in
            switch ch {
            case LogInfoKey.date.rawValue:
                outputString += dateFormatter.string(from: log.date)

            case LogInfoKey.handler.rawValue:
                outputString += log.handlerIdentifier

            case LogInfoKey.level.rawValue:
                outputString += log.level.rawValue

            case LogInfoKey.levelSymbol.rawValue:
                outputString += log.level.symbol

            case LogInfoKey.message.rawValue:
                outputString += log.message.description

            case LogInfoKey.thread.rawValue:
                log.thread.flatMap { outputString += $0 }

            case LogInfoKey.function.rawValue:
                outputString += log.function

            case LogInfoKey.file.rawValue:
                log.fileName.flatMap { outputString += $0 }

            case LogInfoKey.line.rawValue:
                outputString += "\(log.line)"

            case LogInfoKey.path.rawValue:
                outputString += log.file

            case LogInfoKey.metadata.rawValue:
                log.metadata?.toJSONString(writingOption)
                    .flatMap { outputString += $0 }

            default:
                outputString += String(ch)
            }
        }
        let cleanedOutput = outputString
            .trimmingCharacters(in: .whitespaces)

        return .success(cleanedOutput)
    }
}

/// Defines all the possible keys supported by `StringLogFormatter`
enum LogInfoKey: Character {

    /// The time the `Log` instance was originated at.
    case date = "D"

    /// The logger identifier the `Log` instance  was originated from.
    case handler = "H"

    /// The `Log`'s level name
    case level = "l"

    /// The `Log`'s level name all cap
    case levelAllCaps = "L"

    /// The `Log`'s level symbol  i.e. "ℹ️" for info
    case levelSymbol = "S"

    /// The `Log` instance's message.
    case message = "m"

    /// The thread name the `Log` instance was originate from.
    case thread = "T"

    /// The function name the `Log` instance  was originated from.
    case function = "f"

    /// The file name the `Log` was originated from
    case file = "F"

    /// The full path and file name the `Log` message was executed from
    case path = "P"

    /// The line number the `Log` instance  was originated from.
    case line = "#"

    /// Any additional metadata useful to give more metadata to the logs.
    case metadata = "M"
}

//
//  JSONLogFormatter.swift
//  
//
//  Created by Massimo Donati on 6/16/20.
//

import Foundation

/// Formats a Log instance into Json Data
public final class JSONLogFormatter: LogMapper {

    /// use this closure to provide your own mapping logic
    public var customMapper: ((Log) -> [String: Any])?

    public func map(_ log: Log) -> Result<Data, Error> {
        let logJSONObject = customMapper?(log) ?? log.toDictionary()
        do {
            let data = try JSONSerialization.data(
                withJSONObject: logJSONObject,
                options: .withoutEscapingSlashes
            )
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

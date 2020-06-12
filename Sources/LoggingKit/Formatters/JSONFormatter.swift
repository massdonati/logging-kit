//
//  JSONFormatter.swift
//  
//
//  Created by Massimo Donati on 6/16/20.
//

import Foundation

public final class JSONFormatter: LogFormatter {
    public var customMapper: ((Log) -> [String: Any])?
    public func format(_ log: Log) -> Result<Data, Error> {
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

//
//  Extensions.swift
//  
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation
import Logging

extension Logger.Level {
    /// The symble associated to each level.
    var symbol: String {
        switch self {
        case .critical: return "💥"
        case .error: return "♦️"
        case .warning: return "🔶"
        case .info: return "🔷"
        case .debug: return "🐞"
        case .trace: return "🔊"
        case .notice: return "👓"
        }
    }
}

extension Logger.Metadata {
    func toJsonObject() -> [String: Any] {
        return self.mapValues { $0.toJsonObject() }
    }

    func toJSONString() -> String? {
        do {
            let data = try JSONSerialization
                .data(withJSONObject: toJsonObject(),
                      options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            log?.critical("can't decode metadata", metadata: self)
        }
        return nil
    }
}

extension Logger.MetadataValue {

    func toJsonObject() -> Any {
        switch self {
        case.string(let string):
            return string
        case .stringConvertible(let stringConvertible):
            return stringConvertible.description

        case .array(let elements):
            return elements.map { $0.toJsonObject() }
        case .dictionary(let dict):
            return dict.toJsonObject()
        }
    }
}

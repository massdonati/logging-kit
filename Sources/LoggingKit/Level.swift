//
//  Level.swift
//  
//
//  Created by Massimo Donati on 6/18/20.
//

import Foundation
import Logging

public enum Level {
    case only([Logger.Level])
    case all
    case higherThen(Logger.Level)
    case lowerThen(Logger.Level)
    case allBut([Logger.Level])

    func allows(_ level: Logger.Level) -> Bool {
        switch self {
        case .all: return true
        case .only(let allowedLevels):
            return allowedLevels.contains(level)
        case .higherThen(let lowerBound):
            return lowerBound <= level
        case .lowerThen(let higherBound):
            return higherBound >= level
        case .allBut(let excludedLevels):
            return excludedLevels.contains(level) == false
        }
    }
}

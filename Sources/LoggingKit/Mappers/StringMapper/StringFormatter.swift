//
//  StringFormatter.swift
//  
//
//  Created by Massimo Donati on 6/20/20.
//

import Foundation

public protocol StringFormatter {
    func string(from log: Log) -> String
}

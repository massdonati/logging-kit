//
//  LogFormatter.swift
//
//
//  Created by Massimo Donati on 6/15/20.
//

import Foundation

public protocol LogFormatter {
    associatedtype Output
    func format(_ log: Log) -> Result<Output, Error>
}

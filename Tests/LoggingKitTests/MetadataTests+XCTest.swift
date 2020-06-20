//
//  MetadataTests+XCTest.swift
//
//
//  Created by Massimo Donati on 6/20/20.
//
import XCTest

extension MetadataTests {
    static var allTests: [(String, (MetadataTests) -> () throws -> Void)] {
        return [
            ("testCombiningMetadata1", testCombiningMetadata1),
            ("testCombiningMetadata2", testCombiningMetadata2),
        ]
    }
}

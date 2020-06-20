//
//  Utility.swift
//
//
//  Created by Massimo Donati on 6/12/20.
//

import Foundation

func threadName() -> String? {
    #if os(Linux)
    return Thread.current.name
    #else
    return String(
        cString: __dispatch_queue_get_label(nil),
        encoding: .utf8
    )
    #endif
}

func filename(from path: String) -> String? {
    return URL(fileURLWithPath: path)
        .deletingPathExtension()
        .pathComponents
        .last
}

#if os(Linux)
extension DispatchQueue: Equatable {
    public static func ==(lhs: DispatchQueue, rhs: DispatchQueue) -> Bool {
        return lhs.label == rhs.label
    }
}
#endif

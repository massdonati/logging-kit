//
//  Utility.swift
//
//
//  Created by Massimo Donati on 6/12/20.
//

import Foundation

func threadName() -> String? {
    String(cString: __dispatch_queue_get_label(nil),
           encoding: .utf8)
}

func filename(from path: String) -> String? {
    return URL(fileURLWithPath: path).pathComponents.last
}

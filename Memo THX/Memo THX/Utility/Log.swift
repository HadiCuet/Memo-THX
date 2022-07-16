//
//  Log.swift
//  Memo THX
//

import Foundation

struct Log {
    static func info(_ message: String) {
//        #if DEV || STAGE
        print(message)
//        #endif
    }
}

//
//  ImageInfo.swift
//  Memo THX
//
//  Created by Abdullah Al Hadi on 16/7/22.
//

import Foundation

struct ImageInfo: Decodable {
    let urls: URLs
}

struct URLs: Decodable {
    let regular: String
    var regularUrl: URL? {
        return URL(string: regular)
    }
}


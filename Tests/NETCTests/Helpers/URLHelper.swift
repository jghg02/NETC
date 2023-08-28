//
//  URLHelper.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

import Foundation

extension URL {
    static var test = Self(string: "https://jsonplaceholder.typicode.com/comments")!
}

extension URLRequest {
    static var test = Self(url: URL.test)
    static var testWithExtraProperties = Self(
        url: URL.test,
        cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
        timeoutInterval: 42.0
    )
}


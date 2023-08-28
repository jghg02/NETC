//
//  NETCResponse.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

import Foundation

/// Structure to represent an HTTP response.
///
/// This structure contains the headers of the HTTP response and the decoded body of the response.
public struct NETCResponse<N> {
    /// The headers of the HTTP response.
    public let headers: [AnyHashable: Any]
    /// The decoded body of the HTTP response.
    public let value: N
}


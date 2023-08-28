//
//  NETCRequest.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

import Foundation

/// Represents an HTTP request.
///
/// - `NETCHeaders`: A type alias for a dictionary with `String` keys and values representing the HTTP headers.
///
/// The `NETCRequest` class provides a convenient way to construct HTTP requests by specifying the URL, HTTP method, and headers.
/// It also provides a way to convert the `NETCRequest` object into a `URLRequest` object which can be used with networking APIs that expect a `URLRequest`.
public class NETCRequest {
    public typealias NETCHeaders = [String: String]

    /// Creates a new `NETCRequest` object.
    ///
    /// - Parameters:
    ///     - url: The URL for the request.
    ///     - method: The HTTP method for the request. Default is `.GET`.
    ///     - headers: The HTTP headers for the request. Default is an empty dictionary.
    public init(url: URL, method: NETCMethod = .GET, headers: NETCHeaders = [:]) {
        self.url = url
        self.method = method
        self.headers = headers
    }

    // MARK: Internal

    /// Converts the `NETCRequest` object into a `URLRequest` object.
    ///
    /// - Returns: A `URLRequest` object with the same URL, HTTP method, and headers as the `NETCRequest` object.
    var asURLRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        addToRequest(&request)
        return request
    }

    /// A method that can be overridden in subclasses to add additional information to the `URLRequest` object.
    ///
    /// - Parameters:
    ///     - request: The `URLRequest` object to be modified.
    func addToRequest(_ request: inout URLRequest) {}

    // MARK: Private

    private let headers: NETCHeaders
    private let method: NETCMethod
    private let url: URL
}

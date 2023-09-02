//
//  NETCBodyRequest.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

import Foundation

/// A class that represents a request with an HTTP body.
///
/// `NETCBodyRequest` is a subclass of `NETCRequest` that adds an HTTP body to the request.
/// The body is encoded as JSON and the "Content-Type" header is set to "application/json".
///
/// - Since: macOS 10.15
@available(macOS 10.15, *)
@available(iOS 13.0, *)
public class NETCBodyRequest<N: Encodable>: NETCRequest {

    /// Initializes a new `NETCBodyRequest` instance.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request. Default is GET.
    ///   - body: The body of the request, which should conform to `Encodable`.
    ///   - headers: The HTTP headers for the request. Default is an empty dictionary.
    public init(url: URL, method: NETCMethod  = .GET, body: N, headers: NETCHeaders = [:]) {
        self.body = body
        super.init(url: url, method: method, headers: headers)
    }

    /// Adds the body and "Content-Type" header to the request.
    ///
    /// This method is called internally to add the body and "Content-Type" header to the request.
    /// The body is encoded as JSON and the "Content-Type" header is set to "application/json".
    ///
    /// - Parameter request: The `URLRequest` to modify.
    override func addToRequest(_ request: inout URLRequest) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = NETCConfig.keyEncodingStrategy
        request.httpBody = try? encoder.encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    /// The body of the request.
    private let body: N

}

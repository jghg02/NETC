//
//  NETCRequestLoader.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

import Foundation
import Combine

/// Protocol to define the requirements for an object that loads `URLRequest` objects.
///
/// The `NETCRequestLoader` protocol defines a single method that takes a `URLRequest` object and returns a publisher that emits the response data and the URL response.
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
public protocol NETCRequestLoader {
    /// Sends an HTTP request and receives the response.
    ///
    /// - Parameters:
    ///     - request: The `URLRequest` object to be sent.
    ///
    /// - Returns: A publisher that emits the response data and the URL response, or an `URLError` if an error occurs.
    func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError>
}

/// Extension of `URLSession` to conform to the `NETCRequestLoader` protocol.
///
/// This extension uses the `dataTaskPublisher(for:)` method of `URLSession` to send the HTTP request and receive the response.
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
extension URLSession: NETCRequestLoader {
    public func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError> {
        return self.dataTaskPublisher(for: request)
            .map { ($0.data, $0.response) }
            .mapError { $0 as URLError }
            .eraseToAnyPublisher()
    }
}

/// Extension of `URLSession` to provide a method for loading data from a URL.
///
/// This extension is deprecated in macOS 12.0 and iOS 15.0. It is recommended to use the built-in API instead.
@available(macOS, deprecated: 12.0, message: "Use the built-in API instead")
@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    @available(macOS 10.15, *)
    /// Loads data from a URL.
    ///
    /// - Parameters:
    ///     - url: The URL to load data from.
    ///
    /// - Returns: A publisher that emits the data and the URL response, or an `URLError` if an error occurs.
    func data(from url: URL) -> AnyPublisher<(Data, URLResponse), URLError> {
        return self.dataTaskPublisher(for: url)
            .map { ($0.data, $0.response) }
            .mapError { $0 as URLError }
            .eraseToAnyPublisher()
    }
}

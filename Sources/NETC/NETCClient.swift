//
//  NETCClient.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

import Foundation
import Combine

/// A `Result` type used by the `NETCClient`.
///
/// - Parameters:
///   - N: The type of the response body, which should conform to `Decodable`.
///   - E: The type of the error, which should conform to `LocalizedError`, `Decodable`, and `Equatable`.
public typealias NETCClientResult<N, E> = Result<NETCResponse<N>, NETCHTTPError<E>>
where N: Decodable, E: LocalizedError & Decodable & Equatable

/// A client for making network requests.
///
/// `NETCClient` is a generic struct that can be used to make network requests and handle the response.
///
/// - Since: macOS 10.15
@available(macOS 10.15, *)
public struct NETCClient<N, E> where N: Decodable, E: LocalizedError & Decodable & Equatable {

    private let requestLoader: NETCRequestLoader
    private var cancellables = Set<AnyCancellable>()

    /// Initializes a new `NETCClient` instance.
    ///
    /// - Parameter requestLoader: The `NETCRequestLoader` to use for making requests.
    /// Default is `NETCConfig.requestLoader`.
    public init(requestLoader: NETCRequestLoader = NETCConfig.requestLoader) {
        self.requestLoader = requestLoader
    }

    /// Makes a request and returns a publisher that publishes the response.
    ///
    /// - Parameter request: The `URLRequest` to send.
    /// - Returns: A publisher that publishes the response as a `NETCResponse` or a `NETCHTTPError`.
    public func request(_ request: NETCRequest) -> AnyPublisher<NETCResponse<N>, NETCHTTPError<E>> {
        return self.request(request.asURLRequest)
    }

    /// Makes a request and returns a publisher that publishes the response.
    ///
    /// - Parameter request: The `URLRequest` to send.
    /// - Returns: A publisher that publishes the response as a `NETCResponse` or a `NETCHTTPError`.
    public func request(_ request: URLRequest) -> AnyPublisher<NETCResponse<N>, NETCHTTPError<E>> {
        return requestLoader.request(request)
            .mapError { _ in NETCHTTPError<E>.unknow }
            .map { data, response -> NETCClientResult<N, E> in
                self.handleResponse(response, with: data)
            }
            .flatMap { result -> AnyPublisher<NETCResponse<N>, NETCHTTPError<E>> in
                switch result {
                case .success(let response):
                    return Just(response)
                        .setFailureType(to: NETCHTTPError<E>.self)
                        .eraseToAnyPublisher()
                case .failure(let error):
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }



    /// Handles the response from the server.
    ///
    /// - Parameters:
    ///   - response: The `URLResponse` received from the server.
    ///   - data: The `Data` received from the server.
    /// - Returns: A `NETCClientResult` indicating whether the response was successful or not.
    private func handleResponse<N>(_ response: URLResponse, with data: Data) -> NETCClientResult<N, E> {
        guard let response = response as? HTTPURLResponse
        else { return .failure(.failedRequest(nil)) }

        if (200 ..< 300).contains(response.statusCode) {
            return handleSuccess(data, headers: response.allHeaderFields)
        } else {
            return handleFailure(data, statusCode: response.statusCode)
        }
    }

    /// Handles a successful response from the server.
    ///
    /// - Parameters:
    ///   - data: The `Data` received from the server.
    ///   - headers: The headers received from the server.
    /// - Returns: A `NETCClientResult` indicating the success response or a failure if the data couldn't be parsed.
    private func handleSuccess<N, E>(_ data: Data, headers: [AnyHashable: Any]) -> NETCClientResult<N, E> {
        if let value: N = parse(data) {
            return .success(NETCResponse(headers: headers, value: value))
        } else {
            return .failure(.responseTypeMismatch)
        }
    }

    /// Handles a failure response from the server.
    ///
    /// - Parameters:
    ///   - data: The `Data` received from the server.
    ///   - statusCode: The status code received from the server.
    /// - Returns: A `NETCClientResult` indicating the failure response or a specific failure if the error data couldn't be parsed.
    private func handleFailure<N, E>(_ data: Data, statusCode: Int) -> NETCClientResult<N, E> {
        if let error: E = parse(data) {
            return .failure(.invalidRequest(error))
        } else {
            return .failure(.invalidResponse(statusCode))
        }
    }

    /// Method to parser the data from services
    /// - Parameter data: Data
    /// - Returns: Struc/Class with al information decoded
    private func parse<N: Decodable>(_ data: Data?) -> N? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = NETCConfig.keyDecodingStrategy
        return try? decoder.decode(N.self, from: data)
    }
}


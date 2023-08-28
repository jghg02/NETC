//
//  NETCHTTPError.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

import Foundation

/// A set of errors that can occur during the network request or response processing.
///
/// - `failedRequest`: The request failed, possibly due to network issues. Contains an optional `URLError`.
/// - `invalidRequest`: The request was invalid, as indicated by the associated `LocalizedError`.
/// - `invalidResponse`: The response was invalid, as indicated by the associated HTTP status code.
/// - `responseTypeMismatch`: The response did not match the expected type.
/// - `unknow`: An unknown error occurred.
public enum NETCHTTPError<N: LocalizedError>: LocalizedError {
    case failedRequest(URLError?)
    case invalidRequest(N)
    case invalidResponse(Int)
    case responseTypeMismatch
    case unknow

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .failedRequest:
            return "The request failed."
        case let .invalidRequest(error):
            return error.localizedDescription
        case let .invalidResponse(statusCode):
            return "The response was invalid (\(statusCode))."
        case .responseTypeMismatch:
            return "The response did not match the expected type."
        case .unknow:
            return "Unknown Error"
        }
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        switch self {
        case let .failedRequest(error):
            return error?.localizedDescription
        case let .invalidRequest(error):
            return error.localizedDescription
        case let .invalidResponse(statusCode):
            return "The server returned a \(statusCode) status code."
        case .responseTypeMismatch:
            return "The response did not match the expected error type."
        case .unknow:
            return "Unknown Error"
        }
    }
}

/// Conform to `Equatable` when `N` conforms to `Equatable`.
extension NETCHTTPError: Equatable where N: Equatable {}

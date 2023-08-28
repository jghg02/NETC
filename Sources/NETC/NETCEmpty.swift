//
//  NETCEmpty.swift
//
//
//  Created by Josue Hernandez on 08-10-22.
//

import Foundation

/// A simple, empty struct that conforms to `Decodable`, `LocalizedError`, and `Equatable`.
/// NETCEmpty can be used as a placeholder for generic type parameters where you need to specify a type
/// that conforms to Decodable, LocalizedError, and Equatable, but you don't actually care about the type itself.
/// This can be useful, for example, in a network request that doesn't return any meaningful data
/// (e.g., a delete request), but you still need to parse the response (or the error) from the server.
public struct NETCEmpty: Decodable, LocalizedError, Equatable {}


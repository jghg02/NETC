//
//  NETCConfig.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

import Foundation

@available(macOS 10.15, *)
/// NETCConfig is an enum that holds the configuration for the network client.
public enum NETCConfig {
    /// The strategy to use for automatically changing the value of keys before decoding.
    public static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    /// The strategy to use for automatically changing the value of keys before encoding.
    public static var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
    /// The request loader used for making network requests. By default, it is URLSession.shared.
    public static var requestLoader: NETCRequestLoader = URLSession.shared

    /// Resets the `keyDecodingStrategy`, `keyEncodingStrategy`, and `requestLoader` to their default values.
    static func resetToDefaults() {
        keyDecodingStrategy = .convertFromSnakeCase
        keyEncodingStrategy = .convertToSnakeCase
        requestLoader = URLSession.shared
    }
}


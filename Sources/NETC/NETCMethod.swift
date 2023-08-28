//
//  NETCMethod.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

/// A set of HTTP methods used to determine the action to be performed for a given HTTP request.
///
/// - `GET`: The GET method requests a representation of the specified resource.
///          Requests using GET should only retrieve data and should have no other effect.
/// - `POST`: The POST method is used to submit data to be processed to a specified resource.
/// - `DELETE`: The DELETE method deletes the specified resource.
/// - `PATCH`: The PATCH method is used to apply partial modifications to a resource.
public enum NETCMethod: String {
    case GET
    case POST
    case DELETE
    case PATCH
}

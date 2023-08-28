//
//  NETCBodyRequestTest.swift
//  
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

@testable import NETC
import XCTest

final class NETCBodyRequestTest: XCTestCase {

    func test_init_encodedBody() throws {
        let request = NETCBodyRequest(url: URL.test, body: TestObject())
        let urlRequest = request.asURLRequest

        let data = try XCTUnwrap(urlRequest.httpBody)
        let object = try? JSONDecoder.convertingKeysFromSnakeCase.decode(TestObject.self, from: data)
        XCTAssertEqual(object, TestObject())
    }


    func test_init_ContentTypeHeaderJSON() {
        let request = NETCBodyRequest(url: URL.test, body: TestObject())
        let urlRequest = request.asURLRequest

        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func test_headers() {
        let request = NETCBodyRequest(url: URL.test, body: TestObject())
        let urlRequest = request.asURLRequest

        XCTAssertNotNil(urlRequest.allHTTPHeaderFields)
    }

    func test_setsHeaderFields() {
        let request = NETCBodyRequest(
            url: URL.test,
            body: TestObject(),
            headers: ["VALUE": "THE-custom-value---"]
        )

        let urlRequest = request.asURLRequest
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "VALUE"), "THE-custom-value---")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func test_useSnakeCase() throws {
        NETCConfig.keyEncodingStrategy = .convertToSnakeCase
        let request = NETCBodyRequest(url: URL.test, body: TestObject())
        let urlRequest = request.asURLRequest
        let data = try XCTUnwrap(urlRequest.httpBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: []) as? [String: String])

        XCTAssertEqual(json["last_name"], "Hernandez")
    }

    func test_useDefaultEncoding() throws {
        NETCConfig.keyEncodingStrategy = .useDefaultKeys
        let request = NETCBodyRequest(url: URL.test, body: TestObject())
        let urlRequest = request.asURLRequest
        let data = try XCTUnwrap(urlRequest.httpBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: []) as? [String: String])

        XCTAssertEqual(json["lastName"], "Hernandez")
    }

}

// MARK: - Helpers

/// Body
struct TestObject: Codable, Equatable {
    let name: String
    let lastName: String

    init(name: String = "Josue", lastName: String = "Hernandez") {
        self.name = name
        self.lastName = lastName
    }
}

struct TestError: LocalizedError, Codable, Equatable {
    let message: String
}

// MARK: - Helper JSONDecoder
extension JSONDecoder {
    static var convertingKeysFromSnakeCase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

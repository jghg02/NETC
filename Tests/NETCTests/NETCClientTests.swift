//
//  NETCBodyRequestTest.swift
//
//
//  Created by Josue German Hernandez Gonzalez on 26-08-23.
//

@testable import NETC
import XCTest
import Combine

final class NETCClientTests: XCTestCase {

    func test_request() {
        let expectation = XCTestExpectation(description: "Request completes")
        var cancellables = Set<AnyCancellable>()

        let request = FakeNETRequest()
        let client = NETCClient<NETCEmpty, NETCEmpty>(requestLoader: request)

        client.request(NETCRequest(url: URL.test))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { data in
                // Handle the received value if needed
                dump(data)
            })
            .store(in: &cancellables)

        XCTAssertEqual(request.lastLoadedRequest, URLRequest.test)

        wait(for: [expectation], timeout: 10.0)
    }


}




// Mock request loader
class FakeNETRequest: NETCRequestLoader {
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: URLError?

    private(set) var lastLoadedRequest: URLRequest?

    func request(_ request: URLRequest) -> AnyPublisher<(Data, URLResponse), URLError> {
        lastLoadedRequest = request

        if let error = nextError {
            return Fail(error: error).eraseToAnyPublisher()
        }

        let data = nextData ?? Data()
        let response = nextResponse ?? HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!

        return Just((data, response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}

// MARK: - Helper JSONDecoder
extension JSONEncoder {
    static var convertingKeysFromSnakeCase: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

//
//  AGNetworkClientTests.swift
//  MedbookTests
//
//  Created by Aswin Gopinathan on 07/04/25.
//

import XCTest
import Foundation
@testable import Medbook

// Mock URLSessionDataTask
class MockURLSessionDataTask: URLSessionDataTask {
    private let completionHandler: (Data?, URLResponse?, Error?) -> Void

    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.completionHandler = completionHandler
    }

    override func resume() {
        // Do nothing, the completion handler will be called directly in the test
    }

    func callCompletion(data: Data?, response: URLResponse?, error: Error?) {
        completionHandler(data, response, error)
    }
}

// Mock URLSession
class MockURLSession: URLSession {
    var mockDataTask: MockURLSessionDataTask?
    var mockError: Error?
    var mockData: Data?
    var mockResponse: URLResponse?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        mockDataTask = MockURLSessionDataTask(completionHandler: completionHandler)
        return mockDataTask!
    }
}

// Mock Codable struct for testing
struct MockResponse: Codable, Equatable {
    let value: String
}

class AGNetworkClientTests: XCTestCase {

    var networkClient: AGNetworkClient!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkClient = AGNetworkClient.shared // Assuming it's a singleton
    }

    override func tearDown() {
        networkClient = nil
        mockSession = nil
        super.tearDown()
    }

    func testMakeRequest_invalidURL() {
        let expectation = XCTestExpectation(description: "Invalid URL completion")
        networkClient.makeRequest(urlString: "invalid url", httpMethod: .get, type: MockResponse.self) { error, response in
            XCTAssertEqual(error, .somethingWentWrong)
            XCTAssertNil(response)
            expectation.fulfill()
        }
    }

    func testMakeRequest_networkError() {
        // Given
        let mockError = NSError(domain: "Network", code: 1, userInfo: nil)
        mockSession.mockError = mockError
        let expectation = XCTestExpectation(description: "Network error completion")

        // When
        networkClient.makeRequest(urlString: "https://example.com/api", httpMethod: .get, type: MockResponse.self) { error, response in
            // Then
            XCTAssertEqual(error, .somethingWentWrong)
            XCTAssertNil(response)
            expectation.fulfill()
        }

        mockSession.mockDataTask?.callCompletion(data: nil, response: nil, error: mockError)
    }

    func testMakeRequest_invalidData() {
        // Given
        let mockData = Data("{\"invalid\":\"json\"}".utf8)
        mockSession.mockData = mockData
        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com/api")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.mockResponse = mockResponse
        let expectation = XCTestExpectation(description: "Invalid data completion")

        // When
        networkClient.makeRequest(urlString: "https://example.com/api", httpMethod: .get, type: MockResponse.self) { error, response in
            // Then
            XCTAssertEqual(error, .somethingWentWrong)
            XCTAssertNil(response)
            expectation.fulfill()
        }

        mockSession.mockDataTask?.callCompletion(data: mockData, response: mockResponse, error: nil)
    }

    func testMakeRequest_successfulResponse() {
        // Given
        let mockResponseObject = MockResponse(value: "success")
        let mockData = try? JSONEncoder().encode(mockResponseObject)
        mockSession.mockData = mockData
        let mockHttpResponse = HTTPURLResponse(url: URL(string: "https://example.com/api")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.mockResponse = mockHttpResponse
        let expectation = XCTestExpectation(description: "Successful response completion")

        // When
        networkClient.makeRequest(urlString: "https://example.com/api", httpMethod: .get, type: MockResponse.self) { error, response in
            // Then
            XCTAssertNil(error)
            XCTAssertEqual(response, mockResponseObject)
            expectation.fulfill()
        }

        mockSession.mockDataTask?.callCompletion(data: mockData, response: mockHttpResponse, error: nil)
    }
}

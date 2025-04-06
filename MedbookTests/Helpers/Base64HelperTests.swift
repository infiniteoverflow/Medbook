//
//  Base64HelperTests.swift
//  MedbookTests
//
//  Created by Aswin Gopinathan on 07/04/25.
//

import XCTest
@testable import Medbook

class Base64HelperTests: XCTestCase {

    let base64Helper = Base64Helper()
    let email = "aswin@gmail.com"
    let password = "Aswin1111@"

    func testEncode_validDictionary() {
        let userData = [
            TextConstants.credentialKey: email + password
        ]
        
        let expectedOutput = "eyJjcmVkZW50aWFsIjoiYXN3aW5AZ21haWwuY29tQXN3aW4xMTExQCJ9"
        XCTAssertEqual(base64Helper.encode(userData), expectedOutput)
    }

    func testEncode_emptyDictionary() {
        let input: [String: Any] = [:]
        let expectedOutput = "e30=" // Base64 of {}
        XCTAssertEqual(base64Helper.encode(input), expectedOutput)
    }

    func testEncode_dictionaryWithNilValue() {
        let input: [String: Any] = ["name": "John Doe"]
        // JSONSerialization will skip nil values by default
        let expectedOutput = "eyJuYW1lIjoiSm9obiBEb2UifQ==" // Base64 of {"name":"John Doe"}
        XCTAssertEqual(base64Helper.encode(input), expectedOutput)
    }

    func testDecode_validBase64String() {
        let input = "eyJuYW1lIjoiSm9obiBEb2UiLCJhZ2UiOjMwfQ=="
        let expectedOutput: [String: Any] = ["name": "John Doe", "age": 30]
        let decodedValue = base64Helper.decode(input)
        XCTAssertNotNil(decodedValue)
        XCTAssertEqual((decodedValue! as NSDictionary), (expectedOutput as NSDictionary)) // Compare dictionaries
    }

    func testDecode_emptyBase64String() {
        let input = "e30="
        let expectedOutput: [String: Any] = [:]
        let decodedValue = base64Helper.decode(input)
        XCTAssertNotNil(decodedValue)
        XCTAssertEqual((decodedValue! as NSDictionary), (expectedOutput as NSDictionary))
    }

    func testDecode_invalidBase64String() {
        let input = "this_is_not_valid_base64"
        XCTAssertNil(base64Helper.decode(input))
    }

    func testDecode_base64StringOfInvalidJSON() {
        let input = "dGhpcyBpcyBub3QgSlNPTg==" // Base64 of "this is not JSON"
        XCTAssertNil(base64Helper.decode(input))
    }

    func testDecode_base64StringWithNestedDictionary() {
        let input = "eyJuYW1lIjoiSm9obiBEb2UiLCJhZGRyZXNzIjp7InN0cmVldCI6IjEyMyBNYWluIFN0In19"
        let expectedOutput: [String: Any] = ["name": "John Doe", "address": ["street": "123 Main St"]]
        let decodedValue = base64Helper.decode(input)
        XCTAssertNotNil(decodedValue)
        XCTAssertEqual((decodedValue! as NSDictionary), (expectedOutput as NSDictionary))
    }
}

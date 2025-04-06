//
//  UserDefaultsHelperTests.swift
//  MedbookTests
//
//  Created by Aswin Gopinathan on 07/04/25.
//

import XCTest
@testable import Medbook

class UserDefaultsHelperTests: XCTestCase {

    let userDefaultsHelper = UserDefaultsHelper()
    let testKey = "testKey"

    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test to ensure a clean state
        UserDefaults.standard.removeObject(forKey: testKey)
    }

    override func tearDown() {
        // Clear UserDefaults after each test (though setUp already does this)
        UserDefaults.standard.removeObject(forKey: testKey)
        super.tearDown()
    }

    func testStoreAndGet_string() {
        let testValue = "testString"
        userDefaultsHelper.store(testValue, key: testKey)
        let retrievedValue = userDefaultsHelper.get(for: testKey) as? String
        XCTAssertEqual(retrievedValue, testValue)
    }

    func testStoreAndGet_integer() {
        let testValue = 123
        userDefaultsHelper.store(testValue, key: testKey)
        let retrievedValue = userDefaultsHelper.get(for: testKey) as? Int
        XCTAssertEqual(retrievedValue, testValue)
    }

    func testStoreAndGet_double() {
        let testValue = 3.14
        userDefaultsHelper.store(testValue, key: testKey)
        let retrievedValue = userDefaultsHelper.get(for: testKey) as? Double
        XCTAssertEqual(retrievedValue, testValue)
    }

    func testStoreAndGet_bool() {
        let testValue = true
        userDefaultsHelper.store(testValue, key: testKey)
        let retrievedValue = userDefaultsHelper.get(for: testKey) as? Bool
        XCTAssertEqual(retrievedValue, testValue)
    }

    func testStoreAndGet_array() {
        let testValue = ["apple", "banana", "cherry"]
        userDefaultsHelper.store(testValue, key: testKey)
        let retrievedValue = userDefaultsHelper.get(for: testKey) as? [String]
        XCTAssertEqual(retrievedValue, testValue)
    }

    func testStoreAndGet_dictionary() {
        let testValue = ["key1": "value1", "key2": 123] as [String : Any]
        userDefaultsHelper.store(testValue, key: testKey)
        let retrievedValue = userDefaultsHelper.get(for: testKey) as? [String : Any]
        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(NSDictionary(dictionary: retrievedValue!), NSDictionary(dictionary: testValue))
    }

    func testGet_keyDoesNotExist() {
        let retrievedValue = userDefaultsHelper.get(for: "nonExistentKey")
        XCTAssertNil(retrievedValue)
    }

    func testStore_nilValue() {
        userDefaultsHelper.store("someValue", key: testKey) // Store something first
        userDefaultsHelper.store(nil, key: testKey) // Store nil
        let retrievedValue = userDefaultsHelper.get(for: testKey)
        XCTAssertNil(retrievedValue) // Should be nil after storing nil
    }
}

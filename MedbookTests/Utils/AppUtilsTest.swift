//
//  AppUtilsTest.swift
//  MedbookTests
//
//  Created by Aswin Gopinathan on 07/04/25.
//

import XCTest
@testable import Medbook

class AppUtilsTests: XCTestCase {

    func testIsValidEmail_validEmails() {
        XCTAssertTrue(AppUtils.isValidEmail("test@example.com"))
        XCTAssertTrue(AppUtils.isValidEmail("user.name@subdomain.example.co.uk"))
        XCTAssertTrue(AppUtils.isValidEmail("a+b@example.net"))
    }

    func testIsValidEmail_invalidEmails() {
        XCTAssertFalse(AppUtils.isValidEmail(""))
        XCTAssertFalse(AppUtils.isValidEmail("test"))
        XCTAssertFalse(AppUtils.isValidEmail("test@example"))
        XCTAssertFalse(AppUtils.isValidEmail("@example.com"))
        XCTAssertFalse(AppUtils.isValidEmail("test@.com"))
        XCTAssertFalse(AppUtils.isValidEmail("test@example."))
    }

    func testDoesTextHave8Characters_true() {
        XCTAssertTrue(AppUtils.doesTextHave8Characters("12345678"))
        XCTAssertTrue(AppUtils.doesTextHave8Characters("abcdefgh"))
        XCTAssertTrue(AppUtils.doesTextHave8Characters("a b c d e f g h"))
    }

    func testDoesTextHave8Characters_false() {
        XCTAssertFalse(AppUtils.doesTextHave8Characters(""))
        XCTAssertFalse(AppUtils.doesTextHave8Characters("1234567"))
        XCTAssertFalse(AppUtils.doesTextHave8Characters("abc def"))
    }

    func testDoesTextHaveUppercase_true() {
        XCTAssertTrue(AppUtils.doesTextHaveUppercase("Abcdefg"))
        XCTAssertTrue(AppUtils.doesTextHaveUppercase("abcdefG"))
        XCTAssertTrue(AppUtils.doesTextHaveUppercase("123ABC456"))
    }

    func testDoesTextHaveUppercase_false() {
        XCTAssertFalse(AppUtils.doesTextHaveUppercase("abcdefg"))
        XCTAssertFalse(AppUtils.doesTextHaveUppercase("1234567"))
        XCTAssertFalse(AppUtils.doesTextHaveUppercase(""))
        XCTAssertFalse(AppUtils.doesTextHaveUppercase("a b c"))
    }

    func testDoesTextHaveNumbers_true() {
        XCTAssertTrue(AppUtils.doesTextHaveNumbers("12345"))
        XCTAssertTrue(AppUtils.doesTextHaveNumbers("abc1def"))
        XCTAssertTrue(AppUtils.doesTextHaveNumbers("ABC9XYZ"))
    }

    func testDoesTextHaveNumbers_false() {
        XCTAssertFalse(AppUtils.doesTextHaveNumbers(""))
        XCTAssertFalse(AppUtils.doesTextHaveNumbers("abcdefg"))
        XCTAssertFalse(AppUtils.doesTextHaveNumbers("ABCDEFG"))
        XCTAssertFalse(AppUtils.doesTextHaveNumbers("a b c"))
    }

    func testDoesTextHaveSpecialCharacter_true() {
        XCTAssertTrue(AppUtils.doesTextHaveSpecialCharacter("abc!def"))
        XCTAssertTrue(AppUtils.doesTextHaveSpecialCharacter("ABC$XYZ"))
        XCTAssertTrue(AppUtils.doesTextHaveSpecialCharacter("123#456"))
        XCTAssertFalse(AppUtils.doesTextHaveSpecialCharacter(" ")) // Whitespace is not a special character based on the regex
    }

    func testDoesTextHaveSpecialCharacter_false() {
        XCTAssertFalse(AppUtils.doesTextHaveSpecialCharacter(""))
        XCTAssertFalse(AppUtils.doesTextHaveSpecialCharacter("abcdefg"))
        XCTAssertFalse(AppUtils.doesTextHaveSpecialCharacter("ABCDEFG"))
        XCTAssertFalse(AppUtils.doesTextHaveSpecialCharacter("1234567"))
        XCTAssertFalse(AppUtils.doesTextHaveSpecialCharacter("abc def"))
    }

    func testGenerateBase64String_validInput() {
        let email = "aswin@gmail.com"
        let password = "Aswin1111@"
        let expectedOutput = "eyJjcmVkZW50aWFsIjoiYXN3aW5AZ21haWwuY29tQXN3aW4xMTExQCJ9"

        XCTAssertEqual(AppUtils.generateBase64String(email: email, password: password), expectedOutput)
    }

    func testGenerateBase64String_nilEmail() {
        let password = "password123"
        XCTAssertNil(AppUtils.generateBase64String(email: nil, password: password))
    }

    func testGenerateBase64String_nilPassword() {
        let email = "test@example.com"
        XCTAssertNil(AppUtils.generateBase64String(email: email, password: nil))
    }

    func testGenerateBase64String_bothNil() {
        XCTAssertNil(AppUtils.generateBase64String(email: nil, password: nil))
    }
}

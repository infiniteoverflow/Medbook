//
//  SignupViewModelTests.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import XCTest
import Combine
@testable import Medbook // Replace with your actual app module name

final class SignupViewModelTests: XCTestCase {

    private var viewModel: SignupViewModel?
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = SignupViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Email Validation Tests

    func testValidEmail() {
        guard let viewModel else {
            return
        }
        let validEmails = ["test@example.com", "user.name@subdomain.example.co.uk", "test123@test.io"]
        for email in validEmails {
            viewModel.emailText = email
            XCTAssertTrue(viewModel.emailValidated, "Expected '\(email)' to be a valid email")
        }
    }

    func testInvalidEmail() {
        guard let viewModel else {
            return
        }
        let invalidEmails = ["invalid-email", "no.tld@", "@missingname.com", "space in email @test.com", "test@", ".test@com"]
        for email in invalidEmails {
            viewModel.emailText = email
            XCTAssertFalse(viewModel.emailValidated, "Expected '\(email)' to be an invalid email")
        }
    }

    func testEmptyEmailIsInvalid() {
        guard let viewModel else {
            return
        }
        viewModel.emailText = ""
        XCTAssertFalse(viewModel.emailValidated, "Expected empty email to be invalid")
    }

    // MARK: - Password Validation Tests

    func testPasswordMeetsAllCriteria() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "P@sswOrd1"
        XCTAssertTrue(viewModel.atleastEightCharacters)
        XCTAssertTrue(viewModel.atleastOneNumber)
        XCTAssertTrue(viewModel.uppercaseLetter)
        XCTAssertTrue(viewModel.specialCharacter)
        XCTAssertTrue(viewModel.passwordValidated)
    }

    func testPasswordLessThanEightCharacters() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "P@ss1"
        XCTAssertFalse(viewModel.atleastEightCharacters)
        XCTAssertTrue(viewModel.atleastOneNumber)
        XCTAssertTrue(viewModel.uppercaseLetter)
        XCTAssertTrue(viewModel.specialCharacter)
        XCTAssertFalse(viewModel.passwordValidated)
    }

    func testPasswordMissingNumber() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "P@sswOrd"
        XCTAssertTrue(viewModel.atleastEightCharacters)
        XCTAssertFalse(viewModel.atleastOneNumber)
        XCTAssertTrue(viewModel.uppercaseLetter)
        XCTAssertTrue(viewModel.specialCharacter)
        XCTAssertFalse(viewModel.passwordValidated)
    }

    func testPasswordMissingUppercase() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "p@ssword1"
        XCTAssertTrue(viewModel.atleastEightCharacters)
        XCTAssertTrue(viewModel.atleastOneNumber)
        XCTAssertFalse(viewModel.uppercaseLetter)
        XCTAssertTrue(viewModel.specialCharacter)
        XCTAssertFalse(viewModel.passwordValidated)
    }

    func testPasswordMissingSpecialCharacter() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "PasswOrd1"
        XCTAssertTrue(viewModel.atleastEightCharacters)
        XCTAssertTrue(viewModel.atleastOneNumber)
        XCTAssertTrue(viewModel.uppercaseLetter)
        XCTAssertFalse(viewModel.specialCharacter)
        XCTAssertFalse(viewModel.passwordValidated)
    }

    func testPasswordWithOnlyNumbers() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "12345678"
        XCTAssertTrue(viewModel.atleastEightCharacters)
        XCTAssertTrue(viewModel.atleastOneNumber)
        XCTAssertFalse(viewModel.uppercaseLetter)
        XCTAssertFalse(viewModel.specialCharacter)
        XCTAssertFalse(viewModel.passwordValidated)
    }

    func testPasswordWithOnlyLowercase() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "password"
        XCTAssertTrue(viewModel.atleastEightCharacters) // Fails length too
        XCTAssertFalse(viewModel.atleastOneNumber)
        XCTAssertFalse(viewModel.uppercaseLetter)
        XCTAssertFalse(viewModel.specialCharacter)
        XCTAssertFalse(viewModel.passwordValidated)
    }

    func testPasswordWithOnlyUppercase() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "PASSWORD"
        XCTAssertTrue(viewModel.atleastEightCharacters)
        XCTAssertFalse(viewModel.atleastOneNumber)
        XCTAssertTrue(viewModel.uppercaseLetter)
        XCTAssertFalse(viewModel.specialCharacter)
        XCTAssertFalse(viewModel.passwordValidated)
    }

    func testPasswordWithOnlySpecialCharacters() {
        guard let viewModel else {
            return
        }
        viewModel.passwordText = "!@#$%^&*"
        XCTAssertTrue(viewModel.atleastEightCharacters)
        XCTAssertFalse(viewModel.atleastOneNumber)
        XCTAssertFalse(viewModel.uppercaseLetter)
        XCTAssertTrue(viewModel.specialCharacter)
        XCTAssertFalse(viewModel.passwordValidated)
    }

    // MARK: - Fields Validated Tests

    func testFieldsValidatedWhenBothEmailAndPasswordAreValid() {
        guard let viewModel else {
            return
        }
        viewModel.emailText = "test@example.com"
        viewModel.passwordText = "P@sswOrd1"
        XCTAssertTrue(viewModel.emailValidated)
        XCTAssertTrue(viewModel.passwordValidated)
        XCTAssertTrue(viewModel.fieldsValidated)
    }

    func testFieldsNotValidatedWhenEmailIsInvalid() {
        guard let viewModel else {
            return
        }
        viewModel.emailText = "invalid-email"
        viewModel.passwordText = "P@sswOrd1"
        XCTAssertFalse(viewModel.emailValidated)
        XCTAssertTrue(viewModel.passwordValidated)
        XCTAssertFalse(viewModel.fieldsValidated)
    }

    func testFieldsNotValidatedWhenPasswordIsInvalid() {
        guard let viewModel else {
            return
        }
        viewModel.emailText = "test@example.com"
        viewModel.passwordText = "pass1"
        XCTAssertTrue(viewModel.emailValidated)
        XCTAssertFalse(viewModel.passwordValidated)
        XCTAssertFalse(viewModel.fieldsValidated)
    }

    func testFieldsNotValidatedWhenBothAreInvalid() {
        guard let viewModel else {
            return
        }
        viewModel.emailText = "invalid"
        viewModel.passwordText = "pass"
        XCTAssertFalse(viewModel.emailValidated)
        XCTAssertFalse(viewModel.passwordValidated)
        XCTAssertFalse(viewModel.fieldsValidated)
    }

    // MARK: - Combine Subscription Tests (Optional, but good practice)

    func testEmailTextPublisherTriggersEmailValidation() {
        guard let viewModel else {
            return
        }
        let expectation = XCTestExpectation(description: "Email validation triggered")
        var validationCount = 0

        viewModel.$emailValidated
            .dropFirst() // Ignore initial value
            .sink { _ in
                validationCount += 1
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.emailText = "new@email.com"
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(validationCount, 1, "Email validation should be triggered once on text change")
        XCTAssertTrue(viewModel.emailValidated)
    }

    func testPasswordTextPublisherTriggersPasswordValidationCriteria() {
        guard let viewModel else {
            return
        }
        let expectation = XCTestExpectation(description: "Password criteria triggered")
        var validationCount = 0

        Publishers.CombineLatest4(viewModel.$atleastEightCharacters, viewModel.$atleastOneNumber, viewModel.$uppercaseLetter, viewModel.$specialCharacter)
            .dropFirst()
            .sink { _ in
                validationCount += 1
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.passwordText = "Short1@"
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(validationCount, 4, "Password criteria should be triggered once on text change")
        XCTAssertFalse(viewModel.passwordValidated)
    }

    func testChangesInValidationTriggersFieldsValidated() {
        guard let viewModel else {
            return
        }
        let expectation = XCTestExpectation(description: "fieldsValidated updated")
        var validationCount = 0

        viewModel.$fieldsValidated
            .dropFirst()
            .sink { _ in
                validationCount += 1
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.emailText = "test@example.com"
        viewModel.passwordText = "P@sswOrd1"
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(validationCount, 2, "fieldsValidated should update after both email and password are set")
        XCTAssertTrue(viewModel.fieldsValidated)
    }
}

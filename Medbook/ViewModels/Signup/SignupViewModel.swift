//
//  SignupViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI
import Combine

final class SignupViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    @Published var atleastEightCharacters: Bool = false
    @Published var atleastOneNumber: Bool = false
    @Published var uppercaseLetter: Bool = false
    @Published var specialCharacter: Bool = false
    
    @Published var passwordValidated = false
    @Published var emailValidated = false
    
    @Published var fieldsValidated = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        listenToEmailText()
        listenToPasswordText()
    }
    
    private func listenToEmailText() {
        $emailText
            .sink { [weak self] value in
                guard let self else {
                    return
                }
                emailValidated = isValidEmail(value)
                fieldsValidated = emailValidated && passwordValidated
            }
            .store(in: &cancellables)
    }
    
    private func listenToPasswordText() {
        $passwordText
            .sink { [weak self] value in
                guard let self else {
                    return
                }
                
                atleastEightCharacters = doesTextHave8Characters(value)
                atleastOneNumber = doesTextHaveNumbers(value)
                uppercaseLetter = doesTextHaveUppercase(value)
                specialCharacter = doesTextHaveSpecialCharacter(value)
                
                passwordValidated = atleastEightCharacters && atleastOneNumber && uppercaseLetter && specialCharacter
                fieldsValidated = emailValidated && passwordValidated
            }
            .store(in: &cancellables)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else {
            return false // Empty string is not a valid email
        }

        // A basic regular expression for email validation.
        // This is not a 100% foolproof solution but covers most common cases.
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let isValidEmail = email.range(of: emailRegex, options: .regularExpression) != nil
        return isValidEmail
    }
    
    private func doesTextHave8Characters(_ text: String) -> Bool {
        text.count >= 8
    }
    
    private func doesTextHaveUppercase(_ text: String) -> Bool {
        let uppercaseRegex = "[A-Z]+"
        let hasUppercase = text.range(of: uppercaseRegex, options: .regularExpression) != nil
        return hasUppercase
    }
    
    private func doesTextHaveNumbers(_ text: String) -> Bool {
        let uppercaseRegex = "[0-9]+"
        let hasUppercase = text.range(of: uppercaseRegex, options: .regularExpression) != nil
        return hasUppercase
    }
    
    private func doesTextHaveSpecialCharacter(_ text: String) -> Bool {
        let specialCharacterRegex = "[^a-zA-Z0-9\\s]+" // Matches any character that is NOT a letter, number, or whitespace
        let hasSpecialCharacter = text.range(of: specialCharacterRegex, options: .regularExpression) != nil
        return hasSpecialCharacter
    }
}

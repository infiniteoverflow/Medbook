//
//  AppUtils.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

struct AppUtils {
    static func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else {
            return false // Empty string is not a valid email
        }

        // A basic regular expression for email validation.
        // This is not a 100% foolproof solution but covers most common cases.
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let isValidEmail = email.range(of: emailRegex, options: .regularExpression) != nil
        return isValidEmail
    }
    
    static func doesTextHave8Characters(_ text: String) -> Bool {
        text.count >= 8
    }
    
    static func doesTextHaveUppercase(_ text: String) -> Bool {
        let uppercaseRegex = "[A-Z]+"
        let hasUppercase = text.range(of: uppercaseRegex, options: .regularExpression) != nil
        return hasUppercase
    }
    
    static func doesTextHaveNumbers(_ text: String) -> Bool {
        let uppercaseRegex = "[0-9]+"
        let hasUppercase = text.range(of: uppercaseRegex, options: .regularExpression) != nil
        return hasUppercase
    }
    
    static func doesTextHaveSpecialCharacter(_ text: String) -> Bool {
        let specialCharacterRegex = "[^a-zA-Z0-9\\s]+" // Matches any character that is NOT a letter, number, or whitespace
        let hasSpecialCharacter = text.range(of: specialCharacterRegex, options: .regularExpression) != nil
        return hasSpecialCharacter
    }
    
    static func generateBase64String(email: String?, password: String?) -> String? {
        guard let email, let password else {
            return nil
        }
        let userData = [
            TextConstants.credentialKey: email + password
        ]
        
        return Base64Helper().encode(userData)
    }
}

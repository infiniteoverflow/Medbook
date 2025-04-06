//
//  AppUtils.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

struct AppUtils {
    /// Checks if a given string is a valid email address.
    /// - Parameter email: The string to validate.
    /// - Returns: `true` if the string is a valid email, `false` otherwise.
    static func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else {
            return false // Empty string is not a valid email
        }

        // A basic regular expression for email validation.
        // This is not a 100% foolproof solution but covers most common cases.
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        // Attempts to find a match for the email regular expression within the input string.
        let isValidEmail = email.range(of: emailRegex, options: .regularExpression) != nil
        return isValidEmail
    }

    /// Checks if a given text string has at least 8 characters.
    /// - Parameter text: The string to check.
    /// - Returns: `true` if the string's character count is 8 or more, `false` otherwise.
    static func doesTextHave8Characters(_ text: String) -> Bool {
        text.count >= 8
    }

    /// Checks if a given text string contains at least one uppercase letter.
    /// - Parameter text: The string to check.
    /// - Returns: `true` if the string contains an uppercase letter, `false` otherwise.
    static func doesTextHaveUppercase(_ text: String) -> Bool {
        // Regular expression to match one or more uppercase letters.
        let uppercaseRegex = "[A-Z]+"
        // Attempts to find a match for the uppercase regular expression within the input string.
        let hasUppercase = text.range(of: uppercaseRegex, options: .regularExpression) != nil
        return hasUppercase
    }

    /// Checks if a given text string contains at least one number (digit).
    /// - Parameter text: The string to check.
    /// - Returns: `true` if the string contains a number, `false` otherwise.
    static func doesTextHaveNumbers(_ text: String) -> Bool {
        // Regular expression to match one or more digits (0-9).
        let uppercaseRegex = "[0-9]+"
        // Attempts to find a match for the number regular expression within the input string.
        let hasUppercase = text.range(of: uppercaseRegex, options: .regularExpression) != nil
        return hasUppercase
    }

    /// Checks if a given text string contains at least one special character
    /// (any character that is not a letter, number, or whitespace).
    /// - Parameter text: The string to check.
    /// - Returns: `true` if the string contains a special character, `false` otherwise.
    static func doesTextHaveSpecialCharacter(_ text: String) -> Bool {
        // Regular expression to match one or more characters that are NOT:
        // - a-z (lowercase letters)
        // - A-Z (uppercase letters)
        // - 0-9 (numbers)
        // - \s (whitespace characters)
        let specialCharacterRegex = "[^a-zA-Z0-9\\s]+"
        // Attempts to find a match for the special character regular expression within the input string.
        let hasSpecialCharacter = text.range(of: specialCharacterRegex, options: .regularExpression) != nil
        return hasSpecialCharacter
    }

    /// Generates a Base64 encoded string from the provided email and password.
    /// - Parameters:
    ///   - email: The email string to include in the encoded data.
    ///   - password: The password string to include in the encoded data.
    /// - Returns: A Base64 encoded string containing a dictionary with the email and password,
    ///            or `nil` if either the email or password is `nil`.
    static func generateBase64String(email: String?, password: String?) -> String? {
        // Check if both email and password are not nil. If either is nil, return nil.
        guard let email, let password else {
            return nil
        }
        // Create a dictionary containing the email and password.
        let userData = [
            TextConstants.credentialKey: email + password
        ]

        return Base64Helper().encode(userData)
    }
}

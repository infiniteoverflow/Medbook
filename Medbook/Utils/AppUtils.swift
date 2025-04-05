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
}

//
//  TextConstants.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

struct TextConstants {
    static let emailHintText = "Email"
    static let passwordHintText = "Password"
    static let invalidEmailErrorText = "Please enter a valid email"
    static let credentialKey = "credential"
    
    struct Landing {
        //Image that is shown on the Landing Page
        static let landingPageImage = "landing"
        //Text on the Signup CTA
        static let signupText = "Signup"
        //Text on the Login CTA
        static let loginText = "Login"
        //Navigation Bar title
        static let title = "MedBook"
    }
    
    struct Home {
        static let title = "Which topic interests\nyou today?"
        static let sortTitle = "Sort By:"
        static let navBarLeadingPrimaryIcon = "book.fill"
        static let navBarLeadingSecondaryText = "MedBook"
        static let navBarTrailingPrimaryIcon = "bookmark.fill"
        static let navBarTrailingSecondaryIcon = "delete.left"
    }
}

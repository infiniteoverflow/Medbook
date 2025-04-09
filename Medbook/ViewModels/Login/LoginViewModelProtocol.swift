//
//  LoginViewModelProtocol.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

enum AuthenticationState {
    case success
    case failure(reason: String)
}

protocol LoginViewModelProtocol {
    func validateCredentials(email: String, password: String, completion: (UserObject?) -> Void)
    func onLoginTapped(completion: (UserObject) -> Void)
}

//
//  LoginViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI
import Combine

final class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    let navigationManager: NavigationManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var invalidEmailErrorText: String?
    @Published var loginEnabled = false
    
    private var isEmailValid = false

    init(navigationManager: NavigationManager) {
        self.navigationManager = navigationManager
        
        listenToEmailChange()
        listenToPasswordChange()
    }
    
    private func listenToEmailChange() {
        $emailText
            .sink { [weak self] value in
                guard let self else {
                    return
                }
                
                if value.isEmpty {
                    invalidEmailErrorText = nil
                    loginEnabled = false
                    return
                }
                
                isEmailValid = AppUtils.isValidEmail(value)
                
                if !isEmailValid {
                    invalidEmailErrorText = TextConstants.invalidEmailErrorText
                    loginEnabled = false
                    return
                }
                
                invalidEmailErrorText = nil
                // Login should be enabled if the entered email is valid and password is not empty
                loginEnabled = isEmailValid && !passwordText.isEmpty
            }
            .store(in: &cancellables)
    }
    
    private func listenToPasswordChange() {
        $passwordText
            .sink { [weak self] value in
                guard let self else {
                    return
                }
                
                if value.isEmpty {
                    loginEnabled = false
                    return
                }
                
                loginEnabled = isEmailValid
            }
            .store(in: &cancellables)
    }
    
    func onLoginTapped() {
        validateCredentials(email: emailText,
                            password: passwordText) { state in
            switch state {
            case .success:
                print("Success")
            case .failure(let reason):
                print("Failure: \(reason)")
            }
        }
    }
    
    func validateCredentials(email: String,
                             password: String,
                             completion: (AuthenticationState) -> Void) {
        //TODO: Add logic for validating email and password with DB
    }
}

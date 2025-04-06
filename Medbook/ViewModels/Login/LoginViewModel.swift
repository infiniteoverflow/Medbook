//
//  LoginViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI
import SwiftData
import Combine

final class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    let navigationManager: NavigationManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var invalidEmailErrorText: String?
    @Published var loginEnabled = false
    
    private var isEmailValid = false
    
    let modelContext: ModelContext
    let swiftDataHelper: SwiftDataHelper
    let base64Helper = Base64Helper()

    init(navigationManager: NavigationManager,
         modelContext: ModelContext) {
        self.navigationManager = navigationManager
        self.modelContext = modelContext
        self.swiftDataHelper = SwiftDataHelper(modelContext: modelContext)
        
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
                navigationManager.navigateTo(screen: .home)
            case .failure(let reason):
                print("Failure: \(reason)")
            }
        }
    }
    
    func validateCredentials(email: String,
                             password: String,
                             completion: (AuthenticationState) -> Void) {
        let userObjects: [UserObject] = swiftDataHelper.fetchData() ?? []
        if let base64EncodedData = AppUtils.generateBase64String(email: emailText, password: passwordText) {
            let user = userObjects.first { obj in
                obj.encodedCredential == base64EncodedData
            }
            
            return user == nil ? completion(.failure(reason: "No User")) : completion(.success)
        }
        
        return completion(.failure(reason: "No User"))
    }
}

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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var invalidEmailErrorText: String?
    @Published var loginEnabled = false
    @Published var showingAlert = false
    
    private var isEmailValid = false
    
    let modelContext: ModelContext
    let router: LoginViewRouter
    let swiftDataHelper: SwiftDataHelper
    let base64Helper = Base64Helper()

    init(router: LoginViewRouter,
         modelContext: ModelContext) {
        self.modelContext = modelContext
        self.router = router
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
    
    func onLoginTapped(appState: AppState) {
        validateCredentials(email: emailText,
                            password: passwordText) { user in
            if let user {
                appState.user = user
                router.navigateToHome()
            }
        }
    }
    
    func navigateToSignUp() {
        router.navigateToSignUp()
    }
    
    func validateCredentials(email: String,
                             password: String,
                             completion: (UserObject?) -> Void) {
        let userObjects: [UserObject] = swiftDataHelper.fetchData() ?? []
        if let base64EncodedData = AppUtils.generateBase64String(email: emailText, password: passwordText) {
            let user = userObjects.first { obj in
                obj.encodedCredential == base64EncodedData
            }
            
            if user != nil {
                let appPreferenceObject = AppPreferenceObject(encodedCredential: base64EncodedData)
                swiftDataHelper.storeData(appPreferenceObject)
                swiftDataHelper.saveData { _ in
                    //Do nothing as of now
                }
        
                completion(user)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
}

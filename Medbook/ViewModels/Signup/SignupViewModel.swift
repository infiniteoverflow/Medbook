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
    @Published var invalidEmailText: String?
    
    @Published var atleastEightCharacters: Bool = false
    @Published var atleastOneNumber: Bool = false
    @Published var uppercaseLetter: Bool = false
    @Published var specialCharacter: Bool = false
    
    @Published var signupButtonEnabled = false
    
    @Published var isCountriesLoading = true
    @Published var selectedCountry: Country?
    @Published var countriesData: [String: Country]?
    @Published var countriesList: [Country]?
    
    private var passwordValidated = false
    private var isEmailValid = false
    private var countryCode: String?
    private var cancellables = Set<AnyCancellable>()
    private let dispatchGroup = DispatchGroup()
    
    init() {
        fetchCountries()
        fetchCountryCode()
        
        listenToEmailText()
        listenToPasswordText()
        
        handleApiResponses()
    }
    
    private func fetchCountries() {
        dispatchGroup.enter()
        AGNetworkClient.shared.makeRequest(urlString: UrlConstants.countries,
                                           httpMethod: .get,
                                           type: CountriesData.self) { [weak self] error, countriesData in
            guard let self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                
                isCountriesLoading = false
                
                if let error {
                    //TODO: Handle error scenario
                    print(error.localizedDescription)
                    return
                }
                
                self.countriesData = countriesData?.data
                dispatchGroup.leave()
            }
        }
    }
    
    private func fetchCountryCode() {
        if let countryCode = getValueFromUserDefaults(for: UDConstants.defaultCountryCode) {
            self.countryCode = countryCode as? String
        } else {
            fetchIPData()
        }
    }
    
    private func fetchIPData() {
        dispatchGroup.enter()
        AGNetworkClient.shared.makeRequest(urlString: UrlConstants.ip,
                                           httpMethod: .get,
                                           type: IPData.self) { error, ip in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                
                if let error {
                    //TODO: Handle error scenarios
                    print(error.localizedDescription)
                    return
                }
                
                storeInUserDefaults(ip?.countryCode, key: UDConstants.defaultCountryCode)
                countryCode = ip?.countryCode
                dispatchGroup.leave()
            }
        }
    }
    
    private func handleApiResponses() {
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else {
                return
            }
            
            if let countryCode,
               let countries = countriesData?.values {
                selectedCountry = countriesData?[countryCode]
                countriesList = Array(countries).sorted(by: { $0.country ?? "" < $1.country ?? "" })
            }
        }
    }
    
    private func listenToEmailText() {
        $emailText
            .sink { [weak self] value in
                guard let self else {
                    return
                }
                
                if value.isEmpty {
                    invalidEmailText = nil
                    signupButtonEnabled = false
                    return
                }
                
                isEmailValid = AppUtils.isValidEmail(value)
                
                if !isEmailValid {
                    invalidEmailText = TextConstants.invalidEmailErrorText
                    signupButtonEnabled = false
                    return
                }
                
                invalidEmailText = nil
                signupButtonEnabled = isEmailValid && passwordValidated
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
                signupButtonEnabled = isEmailValid && passwordValidated
            }
            .store(in: &cancellables)
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
    
    private func storeInUserDefaults(_ value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    private func getValueFromUserDefaults(for key: String) -> Any? {
        UserDefaults.standard.value(forKey: key)
    }
}

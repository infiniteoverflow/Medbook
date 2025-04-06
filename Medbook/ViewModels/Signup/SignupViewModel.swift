//
//  SignupViewModel.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI
import SwiftData
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
    private var storedCountries = [CountryObject]()
    
    let base64Helper = Base64Helper()
    let userDefaultsHelper = UserDefaultsHelper()
    let swiftDataHelper: SwiftDataHelper
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.swiftDataHelper = SwiftDataHelper(modelContext: modelContext)
        
        fetchCountries()
        fetchCountryCode()
        
        listenToEmailText()
        listenToPasswordText()
        
        handleApiResponses()
    }
    
    func onSubmitTapped(completion: (DataSaveResult) -> Void) {
        if let base64EncodedData = AppUtils.generateBase64String(email: emailText, password: passwordText) {
            let userObject = UserObject(encodedCredential: base64EncodedData)
            swiftDataHelper.storeData(userObject)
            swiftDataHelper.saveData(completion: completion)
        }
    }
    
    private func fetchCountries() {
        dispatchGroup.enter()
        let storedCountries: [CountryObject]? = swiftDataHelper.fetchData()
        if storedCountries == nil || (storedCountries ?? []).isEmpty {
            fetchCountriesFromServer()
        } else if let storedCountries {
            isCountriesLoading = false
            setCountriesList(from: storedCountries)
            dispatchGroup.leave()
        }
    }
    
    private func fetchCountriesFromServer() {
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
    
    private func setCountriesList(from countries: [CountryObject]) {
        countriesList = []
        countriesData = [:]
        countries.forEach { obj in
            let country = Country(object: obj)
            countriesData?[obj.countryCode] = country
            countriesList?.append(country)
        }
    }
    
    private func fetchCountryCode() {
        if let countryCode = userDefaultsHelper.get(for: UDConstants.defaultCountryCode) {
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
                
                userDefaultsHelper.store(ip?.countryCode, key: UDConstants.defaultCountryCode)
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
                
                storeCountriesInLocalStorage()
            }
        }
    }
    
    private func storeCountriesInLocalStorage() {
        countriesData?.enumerated().forEach({ iterator in
            let countryObject = CountryObject(countryCode: iterator.element.key,
                                              item: iterator.element.value)
            modelContext.insert(countryObject)
        })
        
        swiftDataHelper.saveData { result in
            return
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
                
                atleastEightCharacters = AppUtils.doesTextHave8Characters(value)
                atleastOneNumber = AppUtils.doesTextHaveNumbers(value)
                uppercaseLetter = AppUtils.doesTextHaveUppercase(value)
                specialCharacter = AppUtils.doesTextHaveSpecialCharacter(value)
                
                passwordValidated = atleastEightCharacters && atleastOneNumber && uppercaseLetter && specialCharacter
                signupButtonEnabled = isEmailValid && passwordValidated
            }
            .store(in: &cancellables)
    }
}

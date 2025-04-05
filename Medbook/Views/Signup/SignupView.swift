//
//  SignupView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var vm: SignupViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    struct Constants {
        static let title = "Welcome"
        static let subtitle = "sign up to continue"
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    TitleAndSubtitleView(title: Constants.title, subtitle: Constants.subtitle)
                    
                    VStack(spacing: 48) {
                        TextfieldWithDivider(hintText: TextConstants.emailHintText,
                                             dividerColor: ColorConstants.black,
                                             isPassword: false,
                                             text: $vm.emailText,
                                             errorText: $vm.invalidEmailText)
                        TextfieldWithDivider(hintText: TextConstants.passwordHintText,
                                             dividerColor: ColorConstants.black,
                                             isPassword: true,
                                             text: $vm.passwordText,
                                             errorText: .constant(nil))
                    }
                    .foregroundStyle(ColorConstants.black)
                    .padding(.top, 56)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        CheckboxWithText(selected: $vm.atleastEightCharacters, text: "At least 8 characters")
                        CheckboxWithText(selected: $vm.atleastOneNumber, text: "At least 1 number")
                        CheckboxWithText(selected: $vm.uppercaseLetter, text: "Must contain an uppercase letter")
                        CheckboxWithText(selected: $vm.specialCharacter, text: "Contains a special character")
                    }
                    .padding(.top, 32)
                }
                .padding(AuthenticationUI.screenPadding)
                
                if vm.isCountriesLoading {
                    ProgressView()
                        .tint(ColorConstants.primary)
                } else if let countries = vm.countriesList,
                          vm.selectedCountry != nil,
                          !countries.isEmpty {
                    Picker("Countries List", selection: $vm.selectedCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country.country ?? "")
                                .foregroundStyle(ColorConstants.black)
                                .tag(country)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 140)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            
            Spacer()
            
            ButtonView(text: "Let's go",
                       icon: "arrow.forward",
                       enabled: $vm.signupButtonEnabled) {
                vm.onSubmitTapped { result in
                    switch result {
                    case .success:
                        navigationManager.navigateTo(screen: .home)
                    case .failure:
                        //TODO: Handle failure to save data in DB
                        print("Saving data failed")
                    }
                }
            }
        }
        .background(ColorConstants.white)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var modelContext
    SignupView(vm: SignupViewModel(modelContext: modelContext))
}

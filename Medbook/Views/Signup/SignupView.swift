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
        static let emailHintText = "Email"
        static let passwordHintText = "Password"
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(Constants.title)
                            .font(.system(size: 24, weight: .bold))
                        Text(Constants.subtitle)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(ColorConstants.primary)
                    }
                    .foregroundStyle(ColorConstants.black)

                    
                    VStack(spacing: 48) {
                        TextfieldWithDivider(hintText: Constants.emailHintText,
                                             text: $vm.emailText,
                                             dividerColor: ColorConstants.black)
                        TextfieldWithDivider(hintText: Constants.passwordHintText,
                                             text: $vm.passwordText,
                                             dividerColor: ColorConstants.black)
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
                    
                    HStack {
                        Spacer()
                    }
                }
                .padding(24)
            }
            
            Spacer()
            
            ButtonView(text: "Let's go",
                       icon: "arrow.forward",
                       enabled: $vm.fieldsValidated) {
                navigationManager.navigateTo(screen: .home)
            }
        }
        .background(ColorConstants.white)
    }
}

#Preview {
    SignupView(vm: SignupViewModel())
}

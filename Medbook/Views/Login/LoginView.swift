//
//  LoginView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    @EnvironmentObject var appState: AppState
    
    struct Constants {
        static let title = "Welcome,"
        static let subtitle = "log in to continue"
        static let ctaTitle = "Login"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    TitleAndSubtitleView(title: Constants.title, subtitle: Constants.subtitle)
                    
                    VStack(spacing: 48) {
                        TextfieldWithDivider(hintText: TextConstants.emailHintText,
                                             dividerColor: ColorConstants.black,
                                             isPassword: false,
                                             text: $vm.emailText,
                                             errorText: $vm.invalidEmailErrorText)
                        TextfieldWithDivider(hintText: TextConstants.passwordHintText,
                                             dividerColor: ColorConstants.black,
                                             isPassword: true,
                                             text: $vm.passwordText,
                                             errorText: .constant(nil))
                    }
                    .foregroundStyle(ColorConstants.black)
                    .padding(.top, 56)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            
            Spacer()
            
            HStack(alignment: .center) {
                Spacer()
                ButtonView(text: Constants.ctaTitle,
                           icon: ImageConstants.authenticationCTAIcon,
                           enabled: $vm.loginEnabled) {
                    vm.onLoginTapped(appState: appState)
                }
                Spacer()
            }
        }
        .padding(AuthenticationUI.screenPadding)
        .background(ColorConstants.white)
        .alert("No user found, go to Sign up!", isPresented: $vm.showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign up", role: .none) {
                vm.navigateToSignUp()
            }
        }
    }
}

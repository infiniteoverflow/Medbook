//
//  LandingView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    struct Constants {
        //Image that is shown on the Landing Page
        static let landingPageImage = "landing"
        //Height of the Landing Page Image
        static let landingPageImageDimension: CGFloat = 350
        //Text on the Signup CTA
        static let signupText = "Signup"
        //Text on the Login CTA
        static let loginText = "Login"
        //Navigation Bar title
        static let title = "MedBook"
        //Bottom padding for the two buttons at the bottom
        static let buttonsBottomPadding: CGFloat = 8
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image(Constants.landingPageImage)
                        .resizable()
                        .frame(height: Constants.landingPageImageDimension)
                        .padding()
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            
            Spacer()
            HStack(alignment: .center) {
                ButtonView(text: Constants.signupText,
                           icon: nil,
                           enabled: .constant(true)) {
                    navigationManager.navigateTo(screen: .signup)
                }
                ButtonView(text: Constants.loginText,
                           icon: nil,
                           enabled: .constant(true)) {
                    navigationManager.navigateTo(screen: .login)
                }
            }
            .padding(.bottom, Constants.buttonsBottomPadding)
        }
        .navigationTitle(Constants.title)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .background(ColorConstants.primary)
    }
}

#Preview {
    @Previewable @StateObject var navigationManager = NavigationManager()
    
    NavigationView {
        LandingView()
    }
    .environmentObject(navigationManager)
}


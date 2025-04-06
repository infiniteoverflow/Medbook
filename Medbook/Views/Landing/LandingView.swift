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
        //Height of the Landing Page Image
        static let landingPageImageDimension: CGFloat = 350
        //Bottom padding for the two buttons at the bottom
        static let buttonsBottomPadding: CGFloat = 8
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image(TextConstants.Landing.landingPageImage)
                        .resizable()
                        .frame(height: Constants.landingPageImageDimension)
                        .padding()
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            
            Spacer()
            HStack(alignment: .center) {
                ButtonView(text: TextConstants.Landing.signupText,
                           icon: nil,
                           enabled: .constant(true)) {
                    navigationManager.navigateTo(screen: .signup)
                }
                ButtonView(text: TextConstants.Landing.loginText,
                           icon: nil,
                           enabled: .constant(true)) {
                    navigationManager.navigateTo(screen: .login)
                }
            }
            .padding(.bottom, Constants.buttonsBottomPadding)
        }
        .navigationTitle(TextConstants.Landing.title)
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


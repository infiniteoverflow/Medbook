//
//  LandingView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image("landing")
                        .resizable()
                        .frame(height: 350)
                        .padding()
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            
            Spacer()
            HStack(alignment: .center) {
                ButtonView(text: "Signup",
                           icon: nil,
                           enabled: .constant(true)) {
                    navigationManager.navigateTo(screen: .signup)
                }
                ButtonView(text: "Login",
                           icon: nil,
                           enabled: .constant(true)) {
                    navigationManager.navigateTo(screen: .login)
                }
            }
            .padding(.bottom, 8)
        }
        .navigationTitle("MedBook")
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


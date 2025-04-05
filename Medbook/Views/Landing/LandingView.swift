//
//  LandingView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct LandingView: View {
    @State var enabled = true
    
    var body: some View {
        VStack {
            Image("landing")
                .resizable()
                .frame(height: 350)
            Spacer()
            HStack {
                Spacer()
                ButtonView(text: "Signup",
                           icon: nil,
                           enabled: $enabled) {
                    
                }
                ButtonView(text: "Login",
                           icon: nil,
                           enabled: $enabled) {
                    
                }
                Spacer()
            }
            .padding(.bottom, 8)
        }
        .navigationTitle("MedBook")
        .background(ColorConstants.primary)
    }
}

#Preview {
    NavigationView {
        LandingView()
    }
}


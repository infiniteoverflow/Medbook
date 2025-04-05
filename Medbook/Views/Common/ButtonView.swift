//
//  ButtonView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct ButtonView: View {
    let text: String
    let icon: String?
    @Binding var enabled: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Text(text)
                    .foregroundStyle(getColor(for: enabled))
                    .padding(.vertical, 16)
                    .bold()
                
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(getColor(for: enabled))
                        .bold()
                }
            }
        }
        .disabled(!enabled)
        .frame(width: 150)
        .background(ColorConstants.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 2)
                .foregroundStyle(getColor(for: enabled))
        }
    }
    
    private func getColor(for enabled: Bool) -> Color {
        return enabled ? ColorConstants.black : ColorConstants.primary
    }
}

#Preview {
    @Previewable @State var enabled = true
    ButtonView(text: "Signup",
               icon: "arrow.forward",
               enabled: $enabled) {
        print("Tapped")
    }
}

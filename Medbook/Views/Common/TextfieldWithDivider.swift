//
//  TextfieldWithDivider.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct TextfieldWithDivider: View {
    let hintText: String
    let dividerColor: Color
    let isPassword: Bool
    @Binding var text: String
    @Binding var errorText: String?
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 4) {
            if isPassword {
                SecureField("",
                            text: $text,
                            prompt: Text(hintText).foregroundStyle(ColorConstants.primary))
            } else {
                TextField("",
                          text: $text,
                          prompt: Text(hintText).foregroundStyle(ColorConstants.primary))
            }
            Divider()
                .background(dividerColor)
            
            if let errorText,
               !errorText.isEmpty {
                Text(errorText)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var errorText: String? = "Something went wrong"
    TextfieldWithDivider(hintText: "Email",
                         dividerColor: ColorConstants.black,
                         isPassword: true,
                         text: $text,
                         errorText: $errorText)
}

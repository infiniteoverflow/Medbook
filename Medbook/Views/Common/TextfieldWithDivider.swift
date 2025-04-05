//
//  TextfieldWithDivider.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct TextfieldWithDivider: View {
    let hintText: String
    @Binding var text: String
    let dividerColor: Color
    
    var body: some View {
        VStack(spacing: 4) {
            TextField("",
                      text: $text,
                      prompt: Text(hintText).foregroundStyle(ColorConstants.primary))
            Divider()
                .background(dividerColor)
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    TextfieldWithDivider(hintText: "Email", text: $text, dividerColor: ColorConstants.black)
}

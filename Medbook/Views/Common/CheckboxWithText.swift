//
//  CheckboxWithText.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct CheckboxWithText: View {
    @Binding var selected: Bool
    let text: String
    
    struct Constants {
        static let selectedImage = "checkmark.rectangle.fill"
        static let unselectedImage = "square"
        static let dimension: CGFloat = 25
    }
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: selected ? Constants.selectedImage : Constants.unselectedImage)
                .resizable()
                .frame(width: Constants.dimension, height: Constants.dimension)
                .bold()
            
            Text(text)
                .bold()
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(ColorConstants.black)
    }
}

#Preview {
    @Previewable @State var selected = true
    CheckboxWithText(selected: $selected,
                     text: "Atleast 8 characters Atleast 8 characters Atleast 8 characters Atleast 8 characters Atleast 8 characters Atleast 8 characters Atleast 8 characters Atleast 8 characters")
}

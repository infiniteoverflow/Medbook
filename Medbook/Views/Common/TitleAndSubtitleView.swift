//
//  TitleAndSubtitleView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import SwiftUI

struct TitleAndSubtitleView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
            Text(subtitle)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(ColorConstants.primary)
        }
        .foregroundStyle(ColorConstants.black)
    }
}

#Preview {
    TitleAndSubtitleView(title: "Test",
                         subtitle: "Test2")
}

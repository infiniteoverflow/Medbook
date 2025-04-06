//
//  AppProgressView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI

struct AppProgressView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .tint(ColorConstants.primary)
            Spacer()
        }
    }
}

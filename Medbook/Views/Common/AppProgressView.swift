//
//  AppProgressView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 06/04/25.
//

import SwiftUI

///Common view to be used when a progress view needs to be shown to the user.
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

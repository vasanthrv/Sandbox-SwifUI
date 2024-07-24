//
//  UpdatePasswordPage.swift
//  Evangel
//
//  Created by Charisma Infotainment on 19/04/24.
//

import SwiftUI

struct UpdatePasswordPage: View {
    @State var newPassword = ""
    @State var reNewPassword = ""
    
    var body: some View {
        LoginTemplate {
            VStack(alignment: .center, spacing: 20) {
                Text("Update your Password")
                    .bold()
                    .foregroundStyle(.white)
                ESecureField("New Password", text: $newPassword)
                ESecureField("Confirm Password", text: $reNewPassword)
                Button {
                    
                } label: {
                    Text("Update")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 100)
                        .padding(.vertical, 16)
                    //                    .frame(width: 281, height: 51, alignment: .top)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill (
                                    LinearGradient(
                                        colors: [.buttonGradient1.opacity(0.4), .buttonGradient2],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                
                        )
                        .shadow(color: Color(red: 0.1, green: 0.05, blue: 0.34), radius: 15, x: 0, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
//                                .inset(by: 0.5)
                                .stroke(.white, lineWidth: 1)
                                .blendMode(.overlay)
                        )

                }
                
            }
        }
    }
}

#Preview {
    UpdatePasswordPage()
        .ignoresSafeArea()
}

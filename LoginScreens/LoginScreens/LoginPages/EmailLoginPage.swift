//
//  EmailLoginPage.swift
//  Evangel
//
//  Created by Charisma Infotainment on 19/04/24.
//

import SwiftUI

struct EmailLoginPage: View {
    @State var password: String = ""
    var body: some View {
        LoginTemplate {
            VStack(spacing: 22) {
                Text("Enter your Password")
                    .foregroundStyle(.white)
                    .font(.applyFont(.medium, size: 20))
                ESecureField("Password", text: $password)
                Button {
                    
                } label: {
                    PrimaryButton(titleText: "Sign In")
                }
                Text("Forgot password")
                    .font(.applyFont(.semiBold, size: 16))
                  .underline()
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
            }

        }
    }
}

#Preview {
    EmailLoginPage()
        .ignoresSafeArea()
}

struct PrimaryButton: View {
    @State var titleText: String
    
    var body: some View {
        Text(titleText)
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

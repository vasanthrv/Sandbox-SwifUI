//
//  LandingPage.swift
//  Evangel
//
//  Created by Charisma Infotainment on 12/04/24.
//

import SwiftUI

struct LandingPage: View {
    @State var email = ""
    
    var body: some View {
        LoginTemplate {
            VStack(alignment: .center, spacing: 20) {
                Text("Sign In")
                    .bold()
                    .foregroundStyle(.white)
                ETextField("Email / mobile number", text: $email)
                NavigationLink {
                    RegisterPage()
                        .ignoresSafeArea(.all)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Sign In")
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
                HStack(spacing: 28) {
                    //MARK: Apple Button
                    Button {
                        
                    } label: {
                        Image("apple")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 22)
                            .padding(.horizontal, 21)
                            .padding(.vertical, 19)
                            .background(Circle().fill(.white))
                    }
                    //MARK: Google Button
                    Button {
                        
                    } label: {
                        Image("google")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 23)
                            .padding( 19)
                            .background(Circle().fill(.white))
                    }
                }
            }
        }
    }
}


#Preview {
    LandingPage()
        .ignoresSafeArea()
}

//
//  UpdateEmailPage.swift
//  Evangel
//
//  Created by Charisma Infotainment on 19/04/24.
//

import SwiftUI

struct UpdateEmailPage: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var dob: Date = Date()
    @State var password: String = ""
    @State var rePassword: String = ""
    @State var isDatePickerVisible = false
    
    var body: some View {
        LoginTemplate {
            ZStack(alignment: .bottom) {
//                GradientView(yOffset: -120)
                VStack(spacing: 0) {
//                    Spacer()
//                        Image("evangelLogin")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 210, height: 83)

                    VStack(alignment: .center, spacing: 20) {
                        Text("Register")
                            .bold()
                            .foregroundStyle(.white)
                        ETextField("Email / mobile number", text: $email)
                        ESecureField("Password", text: $password)
                        ESecureField("Confirm Password", text: $rePassword)
                        NavigationLink {
                            OTPVerificationView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            PrimaryButton(titleText: "Save")
                        }
                        Button {
                            
                        } label: {
                            Text("Skip")
                                .font(.applyFont(.semiBold, size: 16))
                              .underline()
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                        }

                    }
                }
                if isDatePickerVisible {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isDatePickerVisible = false
                        }
                    DatePicker("", selection: $dob, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.wheel)
    //                    .tint(Color("buttonPurple"))
                        .labelsHidden()
    //                    .padding()
                        .background(
                            ZStack {
                                Color("textFieldBackground")
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.31, green: 0.3, blue: 0.5).opacity(0.5), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.7, green: 0.7, blue: 0.79).opacity(0.2), location: 0.57),
                                        Gradient.Stop(color: .white.opacity(0), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.47, y: 1)
                                )
                            }
                        )
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white.opacity(0.8), lineWidth: 2)
                                .blendMode(.overlay)
                        )
    //                    .padding(.bottom, 30)
                        .cornerRadius(10)
    //                    .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut)
                }
            }
        }
    }
}

#Preview {
    UpdateEmailPage()
        .ignoresSafeArea()
}

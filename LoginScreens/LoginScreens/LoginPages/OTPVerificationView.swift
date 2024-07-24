//
//  OTPVerificationView.swift
//  Evangel
//
//  Created by Charisma Infotainment on 19/04/24.
//

import SwiftUI

struct OTPVerificationView: View {
    @ObservedObject var viewModel = ViewModel()
//    @ObservedObject var viewModel: MobileSignInViewModel
    @State var isFocused = false
    @State private var timerSeconds = 60
    @State private var isTimerRunning = false
    
    
//    let textBoxWidth = UIScreen.main.bounds.width / 8
//    let textBoxHeight = UIScreen.main.bounds.width / 8
    let textBoxWidth:CGFloat = 50
    let textBoxHeight:CGFloat = 50

    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth * 4) + (spaceBetweenBoxes * 3) + ((paddingOfBox * 2) * 3)
    }
    var body: some View {
        LoginTemplate {
            VStack(alignment: .center, spacing: 20) {
                Text("Enter Verfication code")
                
                    .font(.applyFont(.medium, size: 20))
                    .foregroundStyle(.white)
                Text("Verification code has been sent to the registered email address")
                    .font(.applyFont(.regular, size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96).opacity(0.77))
                
                ZStack {
                    HStack(spacing: spaceBetweenBoxes) {
                        ForEach(0..<4, id: \.self) { index in
                            otpText(text: viewModel.otp(at: index))
                        }
                    }
                    
                    TextField("", text: $viewModel.otpField)
                        .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                    //                        .disabled(viewModel.isTextFieldDisabled)
                    
                        .textContentType(.oneTimeCode)
                        .foregroundStyle(.clear)
                        .accentColor(.clear)
                        .background(Color.clear)
                        .keyboardType(.numberPad)
                }
                HStack(spacing: 5) {
                    Button {
                        //                        viewModel.reSendOTP()
                        resetTimer()
                    } label: {
                        Text(viewModel.isResendButtonActive ? "Resend" : "Resend Code in")
                            .font(Font.system(size: 14))
                        //                                .bold()
                            .foregroundStyle(viewModel.isResendButtonActive ? Color("timerColor") : .white)
                    }
                    .disabled(!viewModel.isResendButtonActive)
                    if !viewModel.isResendButtonActive {
                        Text("\(timerSeconds)")
                            .font(Font.system(size: 14))
                        //                                .bold()
                            .foregroundStyle(Color("timerColor"))
                            .onAppear {
                                startTimer()
                            }
                            .onChange(of: timerSeconds) { newValue in
                                if newValue == 0 {
                                    viewModel.isResendButtonActive = true
                                }
                            }
                        Text("s")
                            .font(Font.system(size: 14))
                        //                                .bold()
                            .foregroundStyle(.white)
                    }
                }
                NavigationLink {
                    UpdatePhonePage()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Verify")
                        .font(.applyFont(.bold, size: 16))
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
    
    private func otpText(text: String) -> some View {
        return Text(text)
            .font(.applyFont(.regular, size: 22))
            .foregroundStyle(.white)
            .frame(width: 57, height: 42)
            .background(Color(red: 0.17, green: 0.07, blue: 0.24).opacity(0.58))
//            .padding(paddingOfBox)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 30)
            .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke()
                .foregroundStyle(LinearGradient(colors: [.clear, .white.opacity(0.5)], startPoint: .top, endPoint: .bottom))
            .blendMode(.overlay)
            )

    }
    
    private func resetTimer() {
        timerSeconds = 60
        isTimerRunning = false
        startTimer()
    }
    
    private func startTimer() {
        if !isTimerRunning {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if timerSeconds > 0 {
                    timerSeconds -= 1
                } else {
                    timer.invalidate()
                    isTimerRunning = false
                }
            }
            isTimerRunning = true
        }
    }
}

#Preview {
    OTPVerificationView()
        .ignoresSafeArea()
}

class ViewModel: ObservableObject {
    @Published var otpField = "" {
        didSet {
            guard otpField.count <= 4,
                  otpField.allSatisfy({ $0.isNumber }) else {
                otpField = oldValue
                print(otpField)
                return
            }
        }
    }
    @Published var isResendButtonActive = false
    
    // MARK: Phone Login Firebase
    func otp(at index: Int) -> String {
        guard index < otpField.count else {
            return ""
        }
        return String(Array(otpField)[index])
    }
}

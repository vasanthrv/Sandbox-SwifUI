//
//  LoginTemplate.swift
//  LoginScreens
//
//  Created by Charisma Infotainment on 14/05/24.
//

import SwiftUI

struct LoginTemplate<Content: View> : View {
    private var content: Content
    @State private var yOffset: CGFloat = 0
    var showExtraText: Bool
    var turnOffCredit: Bool
    init(turnOffCredit: Bool = false, showExtraText: Bool = false, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.showExtraText = showExtraText
        self.turnOffCredit = turnOffCredit
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            ZStack(alignment: .bottom) {
                LoginBackground(yOffset: yOffset)
                // MARK: Top Ellipse
                Ellipse()
                    .foregroundColor(.clear)
                    .frame(width: 310.86813, height: 160.32242)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.74, green: 0.18, blue: 1).opacity(0.65), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.5, green: 0.3, blue: 0.93).opacity(0), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.42, y: 0.04),
                            endPoint: UnitPoint(x: 0.53, y: 1.29)
                        )
                    )
                    .blur(radius: 70.5)
                    .rotationEffect(Angle(degrees: -0.39))
                    .offset(x: 220, y: -250)
                
                // MARK: Bottom Ellipse
                Ellipse()
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.74, green: 0.18, blue: 1), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.5, green: 0.3, blue: 0.93).opacity(0), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.42, y: 0.04),
                            endPoint: UnitPoint(x: 0.53, y: 1.29)
                        )
                    )
                    .blur(radius: 60)
                    .frame(width: 363.05267, height: 279.45895)
                    .offset(x: -240, y: -70)
                VStack {
                    Spacer()
                    VStack(spacing: 0){
                        Image("evangelLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 210, height: 83)
                        if !turnOffCredit {
                            Text("By\n Jesus Redeems Ministry")
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.bottom)
                    VStack {
                        if showExtraText {
                            Text("Unlimited Christian \nMovie and Tv Series")
                                .font(.applyFont(.medium, size: 20))
                                .foregroundLinearGradient(colors: [.white, .signOut, .profilePurple], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .frame(width: 320, alignment: .topLeading)
                        }
                        content
                            .padding(.horizontal, 22)
                            .padding(.top, 22)
                            .padding(.bottom, 26)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.31, green: 0.3, blue: 0.5).opacity(0.5), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.7, green: 0.7, blue: 0.79).opacity(0.2), location: 0.57),
                                        Gradient.Stop(color: .white.opacity(0), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.47, y: 1)
                                )
                            )
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                //                        .inset(by: 1)
                                    .stroke(LinearGradient(colors: [.white, .white.opacity(0), .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                                    .blendMode(.overlay)
                            )
                            .padding(.bottom, 40)
                            .padding()
                    }
                        .readSize { sizeV in
                            self.yOffset = screenHeight - (sizeV.height + 507) + 20
                        }
                }
            }
        }
        .adaptsToKeyboard()
        .ignoresSafeArea(.all)
        .onTapGesture {
//            isDatePickerVisible = false
            UIApplication.shared.endEditing() // Dismiss keyboard
        }
    }
}

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension Text {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint) -> some View
    {
        self.overlay {
            
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self
                
            )
        }
    }
}

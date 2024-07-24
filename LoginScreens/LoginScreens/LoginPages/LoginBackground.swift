//
//  LoginBackground.swift
//  LoginScreens
//
//  Created by Charisma Infotainment on 14/05/24.
//

import SwiftUI

struct LoginBackground: View {
    let yOffset: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            ZStack(alignment: .top) {
                Color("bgColor")
                VStack {
                    Image("loginBG")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(y: self.yOffset)
//                    Rectangle()
//                        .fill(.clear)
//                        .frame(height: -self.yOffset)
                }
            }
        }
//        .onAppear {
//            print(yOffset)
//        }
    }
}

#Preview {
    LoginBackground(yOffset: -130)
        .ignoresSafeArea()
}

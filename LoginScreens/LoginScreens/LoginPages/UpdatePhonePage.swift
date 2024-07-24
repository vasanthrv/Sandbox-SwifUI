//
//  UpdatePhonePage.swift
//  Evangel
//
//  Created by Charisma Infotainment on 19/04/24.
//

import SwiftUI

struct UpdatePhonePage: View {
    @State var mobileNo: String = ""
    
    var body: some View {
        LoginTemplate(showExtraText: true) {
            VStack(spacing: 20) {
                Text("Enter your Mobile number")
                    .font(.applyFont(.medium, size: 20))
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                ETextField("mobile number", text: $mobileNo)
                NavigationLink {
                    MobileLoginPage()
                } label: {
                    PrimaryButton(titleText: "Save")
                }
                Text("Skip")
                .font(.applyFont(.semiBold, size: 16))
                  .underline()
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    UpdatePhonePage()
        .ignoresSafeArea()
}

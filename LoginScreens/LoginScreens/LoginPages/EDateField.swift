//
//  EDateField.swift
//  LoginScreens
//
//  Created by Charisma Infotainment on 14/05/24.
//

import SwiftUI

struct EDateField: View {
    var placeholder: String
    @Binding var date: Date
    @Binding var isDatePickerVisible: Bool
    
    init(_ placeholder: String, date: Binding<Date>, visible: Binding<Bool>) {
        self.placeholder = placeholder
        self._date = date
        self._isDatePickerVisible = visible
    }
    
    var body: some View {
        
        HStack(spacing: 12) {
            Image("calender")
                .frame(width: 20)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.4))
                }
                .frame(width: 36)
            ZStack(alignment: .leading) {
                Text(date, style: .date)
                    .foregroundStyle(Color("textColor"))
            }
        }
        .padding(8)
        .frame(width: 313, height: 42, alignment: .leading)
        .background(Color(red: 0.17, green: 0.07, blue: 0.24).opacity(0.2))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 30)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke()
                .foregroundStyle(LinearGradient(colors: [.clear, .white.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                .blendMode(.overlay)
        )
        .onTapGesture {
            isDatePickerVisible.toggle()
        }
    }
}


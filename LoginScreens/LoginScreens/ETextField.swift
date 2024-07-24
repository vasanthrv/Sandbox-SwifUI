//
//  ETextField.swift
//  Mock
//
//  Created by Charisma Infotainment on 11/04/24.
//

import SwiftUI

struct ETextField: View {
    var placeholder: String
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image("phoneEmail")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.black.opacity(0.4))
                }
                .frame(width: 36)
            ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .frame(width: 160, height: 22)
                    .keyboardType(.alphabet)
                if text.isEmpty {
                    Text(placeholder)
                        .font(.applyFont(.regular, size: 17))
                        .foregroundStyle(Color("textColor"))
                }
            }
        }

//        .padding(8)
//        .background {
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(.white.opacity(0.8), lineWidth: 1)
//                .foregroundStyle(Color("textFieldBackground").opacity(0.2))
//                .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 30)
//                .blendMode(.overlay)
//        }
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
            DispatchQueue.main.async {
                isFocused = true // Set isFocused to true when the text field appears
            }
        }
    }
}

struct EPhoneField: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image("phoneEmail")
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.black.opacity(0.4))
                }
                .frame(width: 36)
            Text("+ 91 |")
                .font(.applyFont(.regular, size: 17))
                .foregroundStyle(Color("textColor"))
            ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .frame(width: 160, height: 22)
                    .keyboardType(.phonePad)
                if text.isEmpty {
                    Text("Mobile number")
                        .font(.applyFont(.regular, size: 17))
                        .foregroundStyle(Color("textColor"))
                }
            }
        }
        
        //        .padding(8)
        //        .background {
        //            RoundedRectangle(cornerRadius: 20)
        //                .stroke(.white.opacity(0.8), lineWidth: 1)
        //                .foregroundStyle(Color("textFieldBackground").opacity(0.2))
        //                .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 30)
        //                .blendMode(.overlay)
        //        }
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
            DispatchQueue.main.async {
                isFocused = true // Set isFocused to true when the text field appears
            }
        }
    }
}

struct ESecureField: View {
    var placeholder: String
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image("lock")
//                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.black.opacity(0.4))
                }
                .frame(width: 36)
            ZStack(alignment: .leading) {
                SecureField("", text: $text)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .frame(width: 160, height: 22)
                    .keyboardType(.alphabet)
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(Color("textColor"))
                }
            }
        }

//        .padding(8)
//        .background {
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(.white.opacity(0.8), lineWidth: 1)
//                .foregroundStyle(Color("textFieldBackground").opacity(0.2))
//                .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 30)
//                .blendMode(.overlay)
//        }
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
            DispatchQueue.main.async {
                isFocused = true // Set isFocused to true when the text field appears
            }
        }
    }
}


enum EntryItem {
    case userName
    case mobileMail
    case dob
    
    var imageName: String {
        switch self {
        case .userName:
            ""
        case .mobileMail:
            ""
        case .dob:
            ""
        }
    }
    
    var entryTitle: String {
        switch self {
        case .userName:
            "User Name"
        case .mobileMail:
            "Email / Mobile Number"
        case .dob:
            "Date of Birth"
        }
    }
}

//
//  ContentView.swift
//  CustomVideoPlayer
//
//  Created by Charisma Infotainment on 24/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            Home(size: size, safeArea: safeArea)
                
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
    
}

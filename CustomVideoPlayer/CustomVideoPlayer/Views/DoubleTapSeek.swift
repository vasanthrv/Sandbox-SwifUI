//
//  DoubleTapSeek.swift
//  CustomVideoPlayer
//
//  Created by Charisma Infotainment on 25/04/24.
//

import SwiftUI

/// Seeking Video Forward/Backward with Double Tap  Animation
struct DoubleTapSeek: View {
    var isForward: Bool =  false
    var onTap: () -> Void
    /// Since we have three arrows
    @State private var showArrows: [Bool] = [false, false, false]
    @State private var isTapped: Bool = false
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .overlay {
                Circle()
                    .fill(.black.opacity(0.4))
                    .scaleEffect(2, anchor: isForward ? .leading : .trailing)
            }
            .clipped()
            .opacity(isTapped ? 1 : 0)
        ///Arrows
            .overlay {
                VStack(spacing: 10) {
                    HStack(spacing: 0) {
                        ForEach((0...2).reversed(), id: \.self) { index in
                            Image(systemName: "arrowtriangle.backward.fill")
                                .opacity(showArrows[index] ? 1 : 0.2)
                            
                        }
                    }
                    .font(.title)
                    .rotationEffect(.init(degrees: isForward ? 180 : 0))
                    Text("15 Seconds")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                /// Showing only if tapped
                .opacity(isTapped ? 1 : 0)
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 2) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isTapped = true
                    showArrows[0] = true
                }
                withAnimation(.easeInOut(duration: 0.2).delay(0.2)) {
                    showArrows[0] = false
                    showArrows[1] = true
                }
                withAnimation(.easeInOut(duration: 0.2).delay(0.35)) {
                    showArrows[1] = false
                    showArrows[2] = true
                }
                withAnimation(.easeInOut(duration: 0.2).delay(0.5)) {
                    showArrows[2] = false
                    isTapped = false
                }
                
                /// Calling OnTap Animation After Animation has been initiated
                onTap()
            }
    }
}

#Preview {
    ContentView()
}

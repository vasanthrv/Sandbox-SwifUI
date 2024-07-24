//
//  CustomVideoPlayer.swift
//  CustomVideoPlayer
//
//  Created by Charisma Infotainment on 24/04/24.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = self.player
        controller.showsPlaybackControls = false
        
        return controller
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}

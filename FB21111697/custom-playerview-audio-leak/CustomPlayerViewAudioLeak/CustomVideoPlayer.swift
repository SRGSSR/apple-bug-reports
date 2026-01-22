import AVKit
import SwiftUI

struct CustomVideoPlayer: UIViewControllerRepresentable {
    let player: Player

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }

    func updateUIViewController(_ playerViewController: AVPlayerViewController, context: Context) {
        playerViewController.player = player
    }
}

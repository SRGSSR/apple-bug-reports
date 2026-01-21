import AVKit
import UIKit

final class MainViewController: UIViewController {
    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let openPlayerButton = UIButton(type: .roundedRect)
        openPlayerButton.setTitle("Open player", for: .normal)
        openPlayerButton.addTarget(self, action: #selector(openPlayer(_:)), for: .primaryActionTriggered)
        view.addSubview(openPlayerButton)

        openPlayerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openPlayerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPlayerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc
    private func openPlayer(_ sender: Any) {
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(
            url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
        )
        player.play()
        playerViewController.player = player
        present(playerViewController, animated: true)
    }
}


import AVFoundation
import os

let posterName: StaticString = "Player Lifecycle"
var signPoster = OSSignposter()
var signPosterState: OSSignpostIntervalState?

nonisolated
final class Player: AVPlayer {

    init(url: URL, subsystem: String) {
        Task { @MainActor in
            signPoster = OSSignposter(subsystem: subsystem, category: .pointsOfInterest)
            signPosterState = signPoster.beginInterval(posterName)
        }
        super.init(url: url)
    }

    override init() {
        super.init()
    }

    override init(playerItem: AVPlayerItem?) {
        super.init(playerItem: playerItem)
    }

    deinit {
        Task { @MainActor in
            if let signPosterState {
                signPoster.endInterval(posterName, signPosterState)
            }
        }
    }
}

import AVKit
import SwiftUI

struct ContentView: View {
    @State private var player: AVPlayer = {
        let player = AVPlayer(
            url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")!
        )
        player.audiovisualBackgroundPlaybackPolicy = .automatic
        return player
    }()

    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
            .onAppear(perform: player.play)
    }
}

#Preview {
    ContentView()
}

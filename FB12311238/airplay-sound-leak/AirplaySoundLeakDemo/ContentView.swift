//
//  ContentView.swift
//  AirplaySoundLeakDemo
//
//  Created by Walid on 11.06.23.
//

import AVFoundation
import AVKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        MultiView(
            url1: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10164/4/6A73A62C-E994-4907-B0CD-58E632F43AF6/cmaf.m3u8")!,
            url2: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10148/5/670CE43A-A151-47A9-BBFA-32FE5E86C679/cmaf.m3u8")!
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private enum PlayerPosition {
    case top
    case bottom
}

private struct PlayerView: View {
    let player: AVPlayer
    let action: () -> Void

    var body: some View {
        VideoPlayer(player: player) {
            Button("MAKE ACTIVE", action: action)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top)
                .fontWidth(.condensed)
                .bold()
                .shadow(radius: 1)
        }
    }
}

private struct MultiView: View {
    let url1: URL
    let url2: URL

    @State private var topPlayer = AVPlayer()
    @State private var bottomPlayer = AVPlayer()
    @State private var activePosition: PlayerPosition = .top

    var body: some View {
        VStack {
            playerView(player: topPlayer, position: .top)
            playerView(player: bottomPlayer, position: .bottom)
        }
        .background(.black)
        .onChange(of: activePosition) { position in
            setActive(position: position)
        }
        .onAppear {
            Self.play(url: url1, in: topPlayer)
            Self.play(url: url2, in: bottomPlayer)
            setActive(position: activePosition)
        }
    }

    private static func play(url: URL, in player: AVPlayer) {
        player.replaceCurrentItem(with: .init(url: url))
        player.play()
    }

    private static func make(activePlayer: AVPlayer, inactivePlayer: AVPlayer) {
        activePlayer.allowsExternalPlayback = true
        activePlayer.isMuted = false

        inactivePlayer.allowsExternalPlayback = false
        inactivePlayer.isMuted = true
    }

    @ViewBuilder
    private func playerView(player: AVPlayer, position: PlayerPosition) -> some View {
        PlayerView(player: player) { activePosition = position }
            .saturation(activePosition == position ? 1 : 0)
    }

    private func setActive(position: PlayerPosition) {
        switch position {
        case .top:
            Self.make(activePlayer: topPlayer, inactivePlayer: bottomPlayer)
        case .bottom:
            Self.make(activePlayer: bottomPlayer, inactivePlayer: topPlayer)
        }
    }
}

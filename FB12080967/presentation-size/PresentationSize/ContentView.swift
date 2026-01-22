//
//  ContentView.swift
//  PresentationSize
//
//  Created by Walid on 20.03.23.
//

import AVKit
import Combine
import SwiftUI

enum Stream: String {
    case audio = "https://rts-aod-dd.akamaized.net/ww/13306839/63cc2653-8305-3894-a448-108810b553ef.mp3"
    case video = "https://swi-vod.akamaized.net/videoJson/47603186/master.m3u8"
}

class ContentViewModel: ObservableObject {
    let player = AVPlayer()
    var media: Stream = .video
    var cancellables: [AnyCancellable] = []

    init() {
        updateStream(media: .video)
        configurePublisher()
    }

    func updateStream(media: Stream) {
        self.media = media
        player.replaceCurrentItem(with: .init(url: URL(string: media.rawValue)!))
    }

    private func configurePublisher() {
        player.publisher(for: \.currentItem!.presentationSize)
            .sink { [weak self] size in
                guard let self else { return }
                print("--> [Content type: \(self.media)] - [Airplay: \(self.player.isExternalPlaybackActive)] -> size: \(size)")
            }
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @StateObject var model = ContentViewModel()

    var body: some View {
        ZStack {
            VideoPlayer(player: model.player)
            HStack(spacing: 30) {
                Button("Audio", action: audio)
                    .padding(2)
                    .background(.white)
                Button("Video", action: video)
                    .padding(2)
                    .background(.white)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(.black)
    }

    private func audio() {
        model.updateStream(media: .audio)
    }

    private func video() {
        model.updateStream(media: .video)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

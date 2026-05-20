# Missing item seekable time range information when running as iPad application on macOS

Description of the problem:
---------------------------

When using AVPlayer in an iPad app run on macOS ("Designed for iPad" destination), the reported seekable time ranges for the current player item are incorrect. This prevents players from implementing interactive seek user experiences that can work (e.g. sliders). The system standard player experiences provided by `AVPlayerViewController` or `VideoPlayer` are affected in the same way (sliders cannot be moved).

Remarks:

- Loaded time ranges are correct.
- There is no issue with video or audio served over HLS.


How to reproduce the problem:
-----------------------------

A sample project has been attached to this issue. The app plays an audio MP3, displays the standard player controls (`VideoPlayer`) as well as loaded / seekable time ranges underneath (start of the first time range and end of the last time range). Proceed as follows:

1. Setup code signing for the project.
2. Run on iPadOS first. Observe that the player slider can be moved and that loaded and seekable time ranges are correct.
3. Now run the same app by selecting "My Mac (Designed for iPad)" as destination. Observe that the player slider cannot be dragged anymore and that the seekable time ranges are incorrect, while the loaded time ranges are correct.

Two screenshots have been attached to this issue, one showing time ranges reported on macOS, the other on iPadOS.


Expected results:
-----------------

The reported seekable time ranges for MP3 audio files played with `AVPlayer` are correct in iPad applications run on macOS.


Actual results:
---------------

The reported seekable time ranges for MP3 audio files played with `AVPlayer` are incorrect in iPad applications run on macOS.


Update:
-------

The issue can be fixed by loading the item with "duration" added to the set of automatically loaded asset keys:

```swift
let player = AVPlayer(playerItem: .init(
    asset: .init(url: URL(string: "https://rts-aod-dd.akamaized.net/ww/13306839/63cc2653-8305-3894-a448-108810b553ef.mp3")!),
    automaticallyLoadedAssetKeys: ["duration"]
))
```

Note that AVPlayerItem's header documentation states that:

```swift
/// Initializes an AVPlayerItem with an AVAsset.
/// 
/// Equivalent to -initWithAsset:automaticallyLoadedAssetKeys:, passing @[ @"duration" ] as the value of automaticallyLoadedAssetKeys.
/// 
/// This method, along with the companion `asset` property, is MainActor-isolated for Swift clients because AVAsset is not Sendable. If you are using a Sendable subclass of AVAsset, such as AVURLAsset, an overload of this initializer will be chosen automatically to allow you to initialize an AVPlayerItem while not running on the main actor.
/// 
/// - Parameter asset:
/// 
/// - Returns: An instance of AVPlayerItem
public convenience init(asset: AVAsset)
```

It is therefore likely that either the documentation should be updated to account for a difference in behavior on macOS, or the implementation should be aligned on the documentation so that the indicated set of keys is loaded on all platforms consistently.

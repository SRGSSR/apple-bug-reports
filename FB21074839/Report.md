# AVPlayerViewController in SwiftUI representable: On the tvOS simulator, player resources aren’t released immediately after interaction with menus

Description of the problem:
---------------------------

To play a video on tvOS it is recommended to use the default system player user interface.

AVKit provides `VideoPlayer`  for use in SwiftUI code but, for more advanced use cases (e.g. Picture-in-Picture support), wrapping `AVPlayerViewController` into a `UIViewControllerRepresentable` remains unavoidable.

When using `AVPlayerViewController` wrapped into a `UIViewControllerRepresentable` on the tvOS simulator, we can observe that:

- If the player is opened and closed without other user interaction with the player UI, player-related resources are released immediately.
- If the user interacts with the menus (e.g. subtitles) during playback, though, player-related resources are not released immediately anymore after the player is closed. Sound continues to play in the background for about 10 seconds, after which resources are finally released and sound stops.

This behavior potentially reveals sub-optimal resource-management issues that affect AVKit or SwiftUI in the tvOS simulator context.

### Remarks

- The issue does not arise when the code is run on a physical tvOS device. 
- `VideoPlayer` is not affected.
- The issue does not affect the same implementation when run on iOS (simulator or device).
- The issue does not affect an equivalent UIKit-based implementation which would present `AVPlayerViewController` directly.
- The issue affects all recent simulators (tvOS 18.5, tvOS 26.0, tvOS 26.1 and even tvOS 26.2 beta at the time of this writing).

For all these reasons this issue can likely be considered to be minor. Still it might be related to a deeper root cause you might be interested to investigate.


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. To reproduce:

1. Run the sample project with a tvOS simulator, e.g. the tvOS 26.1 simulator, using Instruments to monitor allocations. Enable sound on your Mac and filter allocations using "AVPlayer".
2. Press the "Open player" button. Observe that AVPlayer-related resources appear in Instruments.
3. Close the player. Observe that AVPlayer-related resources immediately vanish and that sound stops as well.
4. Press the "Open player" button again. Observe that AVPlayer-related resources appear in Instruments. Open the subtitles or the audio menu.
5. Close the player. Observe that AVPlayer-related resources remain visible in Instruments, with sound continuing to play, even though the player UI has disappeared.
6. Wait ~10 seconds. Observe that AVPlayer-related resources disappear automatically in Instruments, with sound stopping.

A video showing the above steps is also attached to this issue.


Expected results:
-----------------

When using `AVPlayerViewController` wrapped in a `UIViewControllerRepresentable` in the tvOS simulator, player-related resources are immediately released by the player user interface when closed, provided they are not retained elsewhere.


Actual results:
---------------

When using `AVPlayerViewController` wrapped in a `UIViewControllerRepresentable` in the tvOS simulator, player-related resources are not released immediately after the user interacts with menus and closes the player. As a result sound continues to play for about 10 seconds.

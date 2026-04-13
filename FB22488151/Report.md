# iOS 26.4 regression: The `.pauses` audiovisual background playback policy does not pause video playback anymore when backgrounding the app


## Description of the problem

Starting with iOS 26.4 and the iOS 26.4 SDK, the `.pauses` audiovisual background playback policy is not correctly applied anymore to an `AVPlayer` having an attached video layer displayed on screen. This means that, when backgrounding a video-playing app (without Picture in Picture support) or locking the device, playback is not paused automatically by the system anymore.

### Remarks

- The buggy background behavior can of course only be seen when the app does not implement Picture in Picture.
- This is not a change of how the `.automatic` audiovisual background playback policy works. Explicitly setting the policy to `.pauses` or `.automatic` namely yields the same incorrect behavior.
- The issue affects iOS and iPadOS in the same way.
- The issue was consistently reproduced on several iOS and iPadOS devices running iOS 26.4, 26.4.1 and 26.5 beta 1.
- The issue does not arise if the app is built with the iOS 26.3 SDK (or earlier) and run on an iOS 26.4+ device.
- The issue does not arise if the app is built with the iOS 26.4 SDK and run on an iOS 26.3 device (or earlier).
- The Apple TV app is affected in the same way, a behavior observed on the lock screen only, though. The Apple TV app namely implements Picture in Picture, preventing the issue from being observed when backgrounding the app.

## How to reproduce the problem

A sample application is attached to this issue. This application displays a `VideoPlayer` (not implementing Picture in Picture) with a pretty standard configuration:

- _Audio, AirPlay, and Picture in Picture_ is enabled for the _Background Modes_ capability.
- The audio session category has been set to `.playback`.
- The player's `audiovisualBackgroundPlaybackPolicy` is the default `.automatic` behavior (the result would be identical if set to `.pauses`).

To reproduce the issue:

1. Build the app with Xcode 26.4 and run the sample application on an iOS 26.4+ device. Playback automatically starts.
2. Send the application to the background. Playback incorrectly continues in the background.
3. Restore the app to the foreground and lock the device. Playback incorrectly continues on the lock screen.

If you reproduce the same scenario using Xcode 26.3 (or earlier) or an iOS 26.3 (or earlier) device, you can observe that playback is correctly paused, both when the app is backgrounded and when the screen is locked.

## How to reproduce the problem (with the Apple TV app)

1. Run the Apple TV app on an iOS 26.4 device.
2. Play some content.
3. Lock the device. Playback incorrectly continues in the background.

If run on iOS 26.3 (or earlier) playback is correctly paused.

## Expected results

When the `AVPlayer` audiovisual background playback policy has been set to `.pauses` (or `.automatic`), video playback is always paused when backgrounding the application or locking the screen.

## Actual results

Starting with iOS 26.4, when the `AVPlayer` audiovisual background playback policy has been set to `.pauses` (or `.automatic`), video playback is not paused when backgrounding the application or locking the screen.

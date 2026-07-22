# iOS 27 beta: AVPlayer with `.automatic` audiovisualBackgroundPlaybackPolicy pauses playback when the Notification Center is opened


## Description of the problem

Since iOS 27 beta, opening the Notification Center while an `AVPlayer` plays audiovisual content causes playback to pause. The app is then suspended after the usual background grace period of roughly 5 seconds, so playback does not resume when the Notification Center is closed. On iOS 26.x the same app continues playing in this situation.

### Remarks

- Setting `audiovisualBackgroundPlaybackPolicy = .continuesIfPossible` does not fully mitigate the issue: with an `AVPictureInPictureController` attached to the layer, audio still stops after about 5 seconds when the Notification Center is open or the device is locked. Only detaching the video layer on backgrounding keeps playback alive.

## How to reproduce the problem

1. Start HLS playback (video with audio, not muted) in the foreground.
2. Swipe down from the top edge to fully open the Notification Center.
3. Wait about 5 seconds.

## Expected results

Playback continues while the Notification Center is open, as on iOS 26.

## Actual results

Playback pauses when the scene enters the background. Audio continues for roughly 5 seconds, then the app is suspended. After closing the Notification Center, the player remains paused and the user must manually resume.

# iOS 26 regression: `AVPlayer.preventsDisplaySleepDuringVideoPlayback` is sometimes ignored after switching between player layers, letting the device incorrectly sleep during video playback

Description of the problem:
---------------------------

Consider an app in which the player view associated with a video player can be switched during playback between:

- A player view whose player layer is enabled for Picture in Picture.
- A player view whose player layer is not enabled for Picture in Picture.

Even if device Auto-lock has been configured, when `preventsDisplaySleepDuringVideoPlayback` has been set to `true` on the `AVPlayer` associated with a visible player view, the device screen should never dim and the device should never auto-lock during video playback.

Since i(Pad)OS 26.0, though, this behavior is broken. After switching between the video player view types described above, the `preventsDisplaySleepDuringVideoPlayback` setting is ignored and screen dimming/device auto-lock are not prevented anymore.

This behavior differs from the usual expected behavior, as observed on iOS 18 and earlier:

- When `preventsDisplaySleepDuringVideoPlayback` is set to `true`, screen dimming and auto-lock must be prevented during video playback, no matter how video layers associated with a player are rewired.
- When set to `false`, screen dimming and auto-lock is allowed during video playback.

Note that this issue affects implementations that use either `AVPlayerViewController` (for the system player UI) or `AVPictureInPictureController` (for a custom UI).

### Remark

- The issue affects i(Pad)OS 26.0, 26.1 and 26.2 beta in the same way. I could e.g. reproduce the issue with my iPhone 14 Pro running iOS 26.1.
- I attempted several workarounds (e.g. forcing a change of `preventsDisplaySleepDuringVideoPlayback` by toggling its value twice) but the behavior sadly seems unrecoverable.


How to reproduce the problem:
-----------------------------

A sample app is attached to this issue. This app implements two separate player views:

- A `BasicVideoView` backed by an `AVPlayerLayer`, not enabled for PiP.
- A `SystemPlayerView` backed by an `AVPlayerViewController`, enabled for PiP.

An `AVPlayer` can be attached to both views. This player is configured with `preventsDisplaySleepDuringVideoPlayback` set to its default value, i.e. `true` for i(Pad)OS

A simple toggle is provided to toggle between both player views during playback.

To reproduce the issue:

1. Grab a device running i(Pad)OS 26 and configure its Auto-lock setting to the minimum value (you can alternatively enable Low Power Mode, which automatically forces a minimum value of 30 seconds).
1. Build and install the sample app on the device. Do not run the app with the debugger attached, as this prevents Auto-lock from kicking in.
2. A video plays automatically. Wait longer than the Auto-lock interval and observe that the screen is correctly prevented from dimming and the device from auto-locking.
3. Now use the available toggle to change the view which displays the content. Wait again and observe that screen dimming incorrectly occurs after a while, after which the device incorrectly auto-locks.

If this scenario is reproduced on an iOS 18 device (or earlier) the behavior is correct.

I attached a video to this issue, showing two iPad devices side-by-side, on the left an iPad Air 5th gen running iPadOS 18.6, on the right an iPad Pro 3rd gen running iPadOS 26.2 beta:

1. The video starts by waking up both devices and showing Low Power Mode is enabled. Both devices can therefore auto-lock within ~30 seconds.
2. The demo app is started. The video plays fine on both devices for ~1 minute without screen-dimming or auto-lock kicking in.
3. The video view is switched on both devices. After ~30 seconds the iPadOS 26.2 device screen dims, after which the screen auto-locks. The iPadOS 18.6 continues playing just fine.


Expected results:
-----------------

If device Auto-lock has been configured, and even if `preventsDisplaySleepDuringVideoPlayback` has been set to `true` on the `AVPlayer` associated with a player view, there are situations which can lead to the device screen still dimming/the device auto-locking during video playback.


Actual results:
---------------

Even if device Auto-lock has been configured, if `preventsDisplaySleepDuringVideoPlayback` has been set to `true` on the `AVPlayer` associated with a player view, the device screen never dims and the device never auto-locks during video playback.

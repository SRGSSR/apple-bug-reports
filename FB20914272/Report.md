# `AVPlayerItem` tracks and presentation size are incorrect when starting playback while AirPlay is enabled

Description of the problem:
---------------------------

When AirPlay has been enabled before starting playback, e.g. from the Control Center, `AVPlayerItem` tracks and presentation size are incorrect:

- `tracks` are empty.
- The `presentationSize` is zero.

These values are correct when starting playback without AirPlay session established, or if a session is established during playback.

Having incorrect values prevents consistent implementation on behaviors that might depend on these values since the result obtained depends on if and when AirPlay has been enabled.

### Remarks

- This issue was initially reported for the `tracks` property only as FB5464600 but was never fixed. I was invited to open a new bug report and, while a bit late, here it is.
- The issue affects iPadOS as well.


How to reproduce the problem:
-----------------------------

A sample project is attached to this feedback. To reproduce the problem:

1. Build and run the app on a physical device connected to a WiFi network. Ensure that an Airplay receiver (e.g. an Apple TV) is available on the same network.
2. Open the player by tapping on the _Open player_ button and check the console. You can observe that non-trivial tracks and presentation size are correctly returned.
3. Close the player and, from the Control Center, enable AirPlay to the receiver on your network.
4. Open the player again and check the console. You can observe that the tracks are unexpectedly empty and the presentation size is zero.
5. While keeping the player open, disable AirPlay and check the console. You can observe that, as soon as playback returns to the local device, the reported tracks and presentation size are correct.

A video is attached to this feedback, showing these steps in detail (captured with an iPhone 14 Pro running iOS 26.1).


Expected results:
-----------------

When playback over AirPlay has been enabled before playback starts, valid tracks and presentation size are returned. This behavior is consistent with local playback or if AirPlay is enabled after playback started.


Actual results:
---------------

When playback over AirPlay has been enabled before playback starts, returned tracks are incorrectly empty and the presentation is incorrectly zero.
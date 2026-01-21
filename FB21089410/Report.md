# Toggling `isMuted` for an `AVQueuePlayer` stops working a short while after the player preloaded its next item in the queue

Description of the problem:
---------------------------

When an `AVQueuePlayer` is loaded with at least two items, and a short while after the next item in the queue has been preloaded, toggling `isMuted` a few times in a row works until it does not work anymore, at which point the player remains silent.

Note that the issue at least affects the two recent major iOS releases (iOS 18 and 26 at the time of this writing).

### Remark

When the player is stuck in silent mode, seeking into the content, pausing or having playback continue with the next item in the queue fixes the issue. This is of course no workaround, though.


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. The demo app is pretty straightforward, playing two Apple Bip Bop streams in a row, relying on an `AVQueuePlayer` for playback and on a `VideoPlayer` for the player user interface.

To reproduce the issue:

1. Run the project on a physical iPhone or iPad (e.g. running iOS 26), ideally with a proxy tool to observe network traffic. Playback of the first video starts automatically. Ensure your device volume is set to a non-zero value.
2. Tap on the mute/unmute button regularly for about 2 minutes. Observe that the behavior is correct and that sound is muted/unmuted accordingly.
3. Seek near the end of the first content (say around the 27-minute mark). Tap on the mute/unmute button regularly during playback of the last minute and observe with the proxy tool when the second stream is preloaded by `AVQueuePlayer`. Continue to tap the mute/unmute button for a while and you should be able to observe that muting/unmuting stops working after the second item has been preloaded.

A video showing the above scenario is also attached to this issue (please watch it with the sound on). It captures a device (mirrored over AirPlay) with its network traffic with Charles proxy.


Expected results:
-----------------

The `AVPlayer` muted property works as expected in all cases, also when using `AVQueuePlayer` loaded with several items.


Actual results:
---------------

The `AVQueuePlayer` muted property stops working shortly after player preloaded the next item its queue. The player then remains silent.
# Playback incorrectly jumps to the live edge when resuming playback of a DVR video livestream after an interruption (e.g. alarm)

Description of the problem:
---------------------------

Interruptions (e.g. alarms) pause `AVPlayer`, resuming playback once the interruption is over (e.g. when the alarm is dismissed).

When playing an on-demand streams this behavior works fine. When playing a video livestream offering a DVR window, though, the player always incorrectly jumps to the live edge after resuming playback, which confuses users.

### Remarks

- The issue was reproduced with iOS 26.2 but affects other versions of the OS as well.
- The behavior is correct if the video URL is played in Safari. In this case playback resumes at the position it was paused at.
- It seems that the problem does not affect audio livestreams supporting DVR.


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. The app is fairly basic, with a `VideoPlayer` displaying a DVR video livestream loaded into an `AVPlayer`. The audio session has been setup to the usual `.playback` catetgory.

To reproduce:

1. Run the demo on a physical device.
2. Prepare a timer firing after ~20 seconds with the Clock app.
3. Return to the demo app and seek somewhere in the middle of the stream.
4. Wait until the timer fires, then dismiss it. You can observe that playback incorrectly jumps to the live edge.

I added a video depicting the above as well.

Expected results:
-----------------

After playback was paused by an interruption, playback resumes at the same position.

Actual results:
---------------

After playback was paused by an interruption, playback always incorrectly resumes at the live edge of DVR video livestreams, which confuses users.
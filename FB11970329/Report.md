# Incorrect progress reported after transitioning between two audio streams played with AVQueuePlayer over AirPlay

Description of the problem:
---------------------------

When transitioning between two audio streams played with `AVQueuePlayer` over AirPlay, progress reported on the sending device is incorrectly stuck at zero after playback of the second item starts. Seeking elsewhere in the stream fixes the issue, though.

Reproduced with iOS 16.2 / 16.3 devices as senders and an Apple TV 4K 16.2 / M1 with macOS Ventura as receivers.

Note that the issue does not occur with other kinds of streams (e.g. HLS video streams).

How to reproduce the problem:
-----------------------------

I attached a sample project to this issue with which the behavior is easy to reproduce. This project plays two audio streams with an `AVQueuePlayer` and uses `VideoPlayer` as player UI:

1. Open the sample project and set a development team for code signing.
2. Run the app on a physical device and enable AirPlay to an available receiver.
3. Seek near the end of the first audio stream being played and wait until the end. Playback continues with the second stream but progress reported on the casting device is stuck at zero.

Note that the progress displayed on the receiver is correctly updated. Seeking elsewhere into the stream also fixes the issue.

I attached a video to this issue showing the above procedure from the casting device point of view.

Expected results:
-----------------

Progress reported when casting over AirPlay is correct, both on device and on the receiver, and for all kinds of contents.


Actual results:
---------------

Progress reported when casting over AirPlay is incorrect on device when chaining audio streams with `AVQueuePlayer`.
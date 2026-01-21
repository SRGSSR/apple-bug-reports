# The next item in an AVQueuePlayer might get skipped when seeking to the end of the current item

Description of the problem:
---------------------------

Sometimes, when seeking to the end of an item loaded in an `AVQueuePlayer` list, the item after it might be skipped entirely, playback resuming with the item further in the list (this of course assumes that at least 3 items have been added to the player queue). This behavior was mostly experienced with audio streams (MP3).

Reproduced on iOS 16.0, 16.1 until 16.3.1, but likely not a recent issue.

Note that this issue might be somehow related to FB12019796.

How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. This project:

- Loads 4 audio MP3s in an `AVQueuePlayer` item list.
- Provides a basic slider which triggers a seek API call when its knob is moved.
- Logs the current player item to the console.

Using this sample application we can reproduce the following incorrect behavior, also visible in the attached video capture:

1. Run the demo on a physical iOS device.
2. Tap on the "Open player" button to start playback.
3. Move the slider knob to the very end of the first item time range. Check the Xcode console output to see that the item correctly changed to the second one.
4. Move the slider knob to the very end of the second item time range. You can now observe that the Xcode console not only logs that playback switched to the third item, but also immediately (and incorrectly) to the fourth one, event though the 3rd item is 55 minute long and should have been played.

Expected results:
-----------------

When seeking to the end of some content played with an `AVQueuePlayer`, the next item played is the next one in the player item list.

Actual results:
---------------

In some cases, when seeking to the end of some content played with an `AVQueuePlayer`, the next item played might be incorrectly skipped.

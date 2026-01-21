# Seek completion handler incorrectly not called in AVQueuePlayer

Description of the problem:
---------------------------

When using `AVPlayer` and the `seek(to:toleranceBefore:toleranceAfter:completionHandler:)` method, we usually expect the completion handler to be called for each seek request, either with its `finished` Boolean set to `true` (seek could complete successfully) or `false` (seek was interrupted by a subsequent seek request).

In the case of an `AVQueuePlayer` loaded with a list of items, though, using this API repeatedly to seek near the end of the current item sometimes lead to the completion handler never called.

How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. This project:

- Loads a few videos in an `AVQueuePlayer` item list.
- Provides a basic slider which triggers a seek API call when its knob is moved.
- Increases a seek counter when a seek API call is made and decreases it when the corresponding completion handler is called. This counter is visible at the top left in the running app.

Using this sample application we can reproduce the following incorrect behavior, also visible in the attached video capture:

1. Run the demo on a physical iOS device.
2. Tap on the "Open player" button to start playback.
3. Seek anywhere in the current item a few times and check that the seek counter correctly changes back and forth between 0 (no active seek) and 1 (during a seek).
3. Grab the slider knob and move it to the very far end without lifting your finger. This creates repeated seek requests with the player still attempting to reach the item end. With a few repeated attempts you should be able to bring the seek counter to 1 when no active seek is made, which proves that a completion handler was never called.

This behavior was tested with recent iOS versions (16.0, 16.1 up to 16.3.1) but is likely not new. It is also possibly related to a few issues with seeks near an item end which I will report separately.

Expected results:
-----------------

When a call to `seek(to:toleranceBefore:toleranceAfter:completionHandler:)` is made, the completion handler is always called.


Actual results:
---------------

When a call to `seek(to:toleranceBefore:toleranceAfter:completionHandler:)` is made, the completion handler is sometimes never called. One such example is when a seek is performed near the end of the current item in an `AVQueuePlayer` item list.
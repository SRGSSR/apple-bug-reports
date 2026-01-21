# AVPlayer MP3 playback issue: Replacing an MP3 with another one after playback failure does not work correctly

Description of the problem:
---------------------------

`AVPlayer` offers the `replaceCurrentItem(with:)` method to replace the current item with another one. After playback of an MP3 fails, though, using this API to replace the failed item with another playable MP3 does not work. No sound can be heard.

Remark: This issue is specific to MP3 (and likely MP4). With HLS streams the behavior is fine.


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. This sample project displays a small UI controlling the content of an underlying `AVQueuePlayer`, initially loaded with an unplayable MP3. The UI offers 3 buttons:

- A button to replace the current item with a playable MP3.
- A button to replace the current item with a playable MP3, but erasing all items in the queue first (this is why `AVQueuePlayer` is used in this sample code, though the reported issue affects `AVPlayer` in general).
- A reset button to replace the current item with the unplayable MP3 initially loaded.

Additionally, current item changes observed via KVO are logged to the console.

To reproduce the issue:

1. Run the demo app in the simulator or on a device. Observe that a playback error is logged to the Xcode console
2. Tap on the "Replace with playable MP3" button. Observe that the item is changed in the console but that no sound can be heard.

A workaround to this issue is to remove all items in the queue before replacing the current item. To verify it:

1. Run the demo app in the simulator or on a device. Observe that a playback error is logged to the Xcode console
2. Tap on the "Replace with playable MP3 (clear first)" button. Observe that the item is changed in the console and that sound is correctly heard. 
3. Tap on the other "Replace with playable MP3". You can hear the MP3 restarting from the beginning, which also indicates that replacing a playable MP3 works, even without clearing the queue first.

This workaround is of course only available when using `AVQueuePlayer`, as the `removeAllItems()` API is not available for `AVPlayer`.


Expected results:
-----------------

When replacing a failed MP3 with another playable MP3, the new playable MP3 plays fine.


Actual results:
---------------

When replacing a failed MP3 with another playable MP3, the new playable MP3 does not play correctly (no sound is heard).

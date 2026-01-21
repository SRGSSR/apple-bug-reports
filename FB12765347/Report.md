# Missing item seekable time range information when running as iPad application on macOS

Description of the problem:
---------------------------

When using AVPlayer in an iPad app run on macOS ("Designed for iPad" destination), the reported seekable time ranges for the current player item are incorrect. This prevents players from implementing interactive seek user experiences that can work (e.g. sliders). The system standard player experiences provided by `AVPlayerViewController` or `VideoPlayer` are affected in the same way (sliders cannot be moved).

Remarks:

- Loaded time ranges are correct.
- There is no issue with video or audio served over HLS.


How to reproduce the problem:
-----------------------------

A sample project has been attached to this issue. The app plays an audio MP3, displays the standard player controls (`VideoPlayer`) as well as loaded / seekable time ranges underneath (start of the first time range and end of the last time range). Proceed as follows:

1. Setup code signing for the project.
2. Run on iPadOS first. Observe that the player slider can be moved and that loaded and seekable time ranges are correct.
3. Now run the same app by selecting "My Mac (Designed for iPad)" as destination. Observe that the player slider cannot be dragged anymore and that the seekable time ranges are incorrect, while the loaded time ranges are correct.

Two screenshots have been attached to this issue, one showing time ranges reported on macOS, the other on iPadOS.


Expected results:
-----------------

The reported seekable time ranges for MP3 audio files played with `AVPlayer` are correct in iPad applications run on macOS.


Actual results:
---------------

The reported seekable time ranges for MP3 audio files played with `AVPlayer` are incorrect in iPad applications run on macOS.

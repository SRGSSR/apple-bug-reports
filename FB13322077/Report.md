# Seek sluggishness when using a Bluetooth headset and a Picture in Picture controller is instantiated

Description of the problem:
---------------------------

When using `AVPictureInPictureController` instantiated for some player layer, and if a Bluetooth headset or headphones are connected (in my case AirPods Pro 2nd gen), performing consecutive seek requests on a player associated with the layer is sluggish.

The sluggishness disappears if:

- No `AVPictureInPictureController` is associated with the layer.
- The headset / headphones are disconnected.
- Playback is paused.

Tested on an iPhone 14 Pro running iOS 17.1 as well as an iPhone XS running 17.2 beta.


How to reproduce the problem:
-----------------------------

I attached a sample project to this issue. This project simply wraps an `AVPlayerViewController`, enabled for PiP by default, into a SwiftUI view and uses it to play a livestream with timeshift support:

1. Run the attached project on a device. Do not connect any Bluetooth headset yet.
2. Seek several times back and forth in a row. Observe that the experience is smooth, as expected.
3. Connect a headset, restart the demo and seek several times back and forth again in a row. Observe that some seeks are now extremely sluggish, even on fast devices.


Expected results:
-----------------

`AVPictureInPictureController` and Bluetooth used together do not lead to sluggishness when seeking.


Actual results:
---------------

`AVPictureInPictureController` and Bluetooth used together lead to sluggish seeks.

Update 1:
---------

I found that the issue appears when you Spatial or Fixed modes are enabled with AirPods. I was not able to capture the issue on device since the screen capture disables these modes automatically.

I therefore used another device to capture three scenarios you will find in attached videos, all of them executed on an iPhone 14 Pro running iOS 17.1:

- No headphones. Seeking works as expected.
- Spatial off: Seeking works as expected.
- Spatial on: You can observe that I have a hard time moving the slider back and forth, the player struggling to follow my interactive seek requests. This is what I describe as "sluggish" in my initial report.

Update 2:
---------

I also want to add more information to my initial bug report, now that the issue can be clearly related to Spatial audio (fixed / head tracking):

1. I can confirm that the issue does not appear if seeking is made while the player is paused.
2. I can also confirm that the issue is related to PiP controller presence. Sadly you cannot reproduce the issue with `AVPlayerViewController` since setting `allowsPictureInPicturePlayback` does not change anything. I suspect that a PiP controller is still instantiated internally. In our custom player implementation, though, we do not instantiate any PiP controller if PiP is not desired, in which case the seeking experience is smooth, also when Spatial audio is enabled.
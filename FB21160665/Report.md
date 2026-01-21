# tvOS 26 regression: Huge memory leaks associated with navigation marker artworks displayed in the tvOS standard user interface

Description of the problem:
---------------------------

The tvOS standard media player user interface (`AVPlayerViewController` or `VideoPlayer`) is able to display chapters through navigation markers associated with an `AVPlayerItem`, as described in the [official documentation](https://developer.apple.com/documentation/avkit/presenting-navigation-markers).

Starting with tvOS 26, though, markers which have an associated artwork (`.commonIdentifierArtwork`) will leak associated `CoreImage`s memory in chunks of several MiBs each time an item with navigation markers is played. The more chapters with an artwork are displayed, the faster this memory leak grows.

Over time the leak leads to the system killing the application due to excessive memory consumption.

### Remark

As far as I could check with the devices and simulators I have on older versions, the leak did not exist prior to tvOS 26. This is why I reported this issue as a tvOS 26 regression.


How to reproduce the problem:
-----------------------------

A SwiftUI sample app is attached to this issue. This tvOS application presents a button, with which a player can be opened. The item being played is attached 5 chapters, with artworks loaded from a local asset catalog.

To reproduce

1. Run the project on a tvOS 26 device using Instruments and the Allocations instrument. Check "All Heap & Anonymous VM" initial memory amount.
2. Open the player and wait until playback starts. Close the player. Check "All Heap & Anonymous VM" memory amount after stabilization.
3. Repeat many times and observe that several MiB are leaked each time the player is opened and closed.
4. Click on the circled arrow next to the "All Heap & Anonymous VM" label, order statistics by descending size, and observe that a bunch of `CoreImage`s persist in memory. You can observe that these allocations involve `AVUnifiedPlayerNavigationThumbnailUtilities` in their stack trace, relating them to the chapter navigation interface.

A screenshot of the allocation statistics on tvOS 26 is attached to this issue. I also attached a screenshot of allocation statistics on tvOS 18 (afer having opened and closed the player ~10 times).

I also attached a video showing the above scenario, with the tvOS 26 simulator and Instruments for ease of capture. I still recommend to use a physical devices though you can observe the aforementioned leak in the simulator as well.

My setup:

- Xcode 26.1.1
- tvOS 26.1/26.2 beta 2 and 18.5

### Remark

- The issue is identical if `VideoPlayer` is replaced with an `AVPlayerViewController`.
- My personal Apple TV still runs tvOS 18.5 (its sysdiagnose is therefoe attached). Devices running tvOS 26 versions all belong to my workplace.


Expected results:
-----------------

The tvOS standard media player user experience works well and does not leak memory.


Actual results:
---------------

Artworks associated with chapters displayed in the tvOS media player user experience leak significant amounts of memory. This leads to the system killing the application when memory consumption is excessive.

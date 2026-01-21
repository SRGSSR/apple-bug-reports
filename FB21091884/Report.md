# `AVPlayer` tvOS issue: Resources associated with a player and its items might be released after a long delay when a resource loader delegate is involved

Description of the problem:
---------------------------

An `AVPlayerItem` can be optionally attached an `AVAssetResourceLoaderDelegate` responsible of loading resources associated with its associated asset.

Once finished, resource delegate implementations are expected to call the `finishLoading` method on the associated `AVAssetResourceLoadingRequest`, informing the resource loader that the loading request completed. The actual loading process can take an unspecified amount of time, though, for example if it involves network requests that are slow to complete (e.g. poor network conditions).

At any time during the lifetime of a player, the current item of an `AVPlayer` can be replaced by calling `AVPlayer.replaceCurrentItem(with:)`. If this method is called to replace a resource-loaded `AVPlayerItem` that has not finished processing its loading request (i.e. the `finishLoading` method was not called), cleanup of some resources will be deferred for some reason on tvOS, though.

This typically means that, if an `AVPlayerViewController`-based view owning an `AVPlayer` is closed on tvOS, and if a resource loader delegate could not finish its work, player-related resources will need between 10 and 20 seconds after the view was closed to be properly released. During this time sound (if any) can still be heard in background, which leads to a poor user experience.

### Remarks

- The issue affects recent versions of tvOS (tvOS 18 and tvOS 26, including tvOS 26.2 beta 2 at the time of this writing). This is therefore not a recent regression.
- i(Pad)OS is not affected, which points at tvOS specific implementation details. During my investigations I namely stumbled upon stack traces involving `AVContentRestrictionsViewController`, which is only available on tvOS. Maybe this issue is related to tvOS-specific behaviors such as content restriction support.


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. The sample app provides a button to open the standard player user experience, implemented by wrapping an `AVPlayerViewController` into a SwiftUI `UIViewControllerRepresentable` so that buttons can be added to its transport bar.

The player initially starts empty, but its transport bar provides a media icon which makes it possible to load two kinds of `AVPlayerItem`s:

1. A slow loading item, backed by an `AVAssetResourceLoaderDelegate` that simulates a slow resource loading process that calls `finishLoading` after 100 seconds.
2. A normal item loading Apple's 16:9 Bip Bop stream.

A third _[FIX]_ media entry is available. This entry will be discussed in the _Workaround_ section below. Please ignore it for now.

To reproduce the issue:

1. Run the demo on a **physical tvOS device**, using Instruments and its Allocations instrument. Filter allocations with the "AVPlayer" filter.
2. Open the player with the dedicated button, then close it. Observe with Instruments that resources are properly released.
3. Open the player and load Apple's 16:9 Bip Bop stream, then close the player. Observe with Instruments that resources are properly released.
4. Open the player, load the "Slow loading item" first (the player displays a loading indicator but no content starts playing, of course), then Apple's 16:9 Bip Bop stream after a few seconds. Close the player and observe with Instruments that many resources are not released, with sound still playing in the background. Wait 10 to 20 seconds, until you can observe that resources are deallocated, with sound stopping at the same time.

A `bug_demo` video of the above scenario is attached to this issue as well.

### Remarks

- Please avoid the tvOS simulator. The demo namely uses the transport bar to provide a media selection button and I identified another similar issue, affecting only the tvOS simulator, leading to resources being deallocated at a later time after transport bar item menus have been opeded. This issue has been reported as FB21074839 and possibly shares common roots with the present issue.
- The demo project also runs on iOS. If you reproduce the above steps on iOS you can observe that resources are always properly released ASAP.


Expected results:
-----------------

When an `AVPlayerItem` is replaced with another one by calling `AVPlayer.replaceCurrentItem(with:)`, related resources are always released ASAP. As a result the player does not unnecessarily keep player-related resources alive, which avoids content being played in the background unncessarily for a while.


Actual results:
---------------

On tvOS, replacing an item with a `AVAssetResourceLoaderDelegate` that didn't finish its work leads to some resources being released only a while later (10 to 20 seconds). This can lead to a suboptimal user experience since a closed player might surprisingly continue to play in background for a while.


Workaround:
-----------

A naive idea is that calling `cancelLoading()` on the asset associated with the current item before replacing it with another item might possibly cancel pending processes that make resources being retained for more time than necessary.

This intuition works but, for reasons difficult to determine without access to the underlying AVFoundation implementation, a small delay must be introduced before triggering cancellation.

You can test this workaround with the sample app as follows:

1. Run the demo on a **physical tvOS device**, using Instruments and its Allocations instrument. Filter allocations with the "AVPlayer" filter.
2. Open the player, load the "Slow loading item" first (the player displays a loading indicator but no content starts playing, of course), then the **[FIX]** Apple's 16:9 Bip Bop stream after a few seconds. This third entry implements a custom `AVPlayer.cancelLoadingAndReplaceCurrentItem(with:)` method which replaces the current item while cancelling assset loading for it after a short while (1/2 second). Close the player and observe with Instruments that all player-related resources are now correclty released immediately.

A `workaround_demo` video of the above scenario is attached to this issue as well.

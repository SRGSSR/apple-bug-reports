# The standard system playback user interface should only display variants available from a downloaded movpkg

## Description of the problem

HLS streams downloaded with AVFoundation `AVAssetDownloadURLSession` may not locally contain all audible or legible variants declared by a master playlist.

When playing a downloaded stream, the system player user interface (`AVPlayerViewController`, `VideoPlayer`) attempts to maximize the number of options to pick from:

- If the device is online all options from the original playlist are offered by the standard player UI menu.
- If the device is offline (Airplane mode without WiFi) only options available from the local movpkg are offered.

There are three problems with this user experience:

- Content is downloaded by a user for a reason, often because of data plan constraints in foreign countries. If a user is playing a downloaded content but has a network connection, and if they pick a variant that is not available offline, data will still be silently transferred over the network. This is not a behavior that is expected, especially when each MB counts.
- Enabling/disabling the network connection during playback does not update the list between offline and online variants accordingly. The list is ultimately the one that was presented when the player was opened, depending on whether the device was online or offline at that time.
- A user might start playback online, with all options presented. If they go offline afterwards and pick another variant that is not available locally, the player will get stuck, as it attempts to load missing segments from the network instead.

For all these reasons, when playing a downloaded stream only options available locally according to `AVAssetCache` should be returned. This is true whether the device is online or offline.

### Remarks

- This issue affects all recent OS versions from iOS 16 up to iOS 27 beta 6 (probably earlier ones as well but I could not check).
- We reported a related issue _AVFoundation: Offline playback fails due to media selection picking variants declared in the master playlist but not available offline_, filed under FB24445920.

## How to reproduce the problem

A sample project is attached to this issue. Due to the many pieces required for a complete implementation, I rather started from the official [AVFoundation HLSCatalog  download sample](https://developer.apple.com/documentation/avfoundation/using-avfoundation-to-play-and-persist-http-live-streams) and tweaked it very slightly. Note that this project is sadly not compatible with iOS 27, as it was not updated for scene support. The following changes were made:

- A trailer of "The Morning Show" from Apple TV, with many subtitles and audio variants to pick from, was added to the example list.
- The `AVAssetDownloadConfiguration` was edited to download a low quality (for faster tests; nothing related to the present issue).

To reproduce the issue:

1. Run the sample project on a physical device.
2. Download "The Morning Show" example (via the info button). This downloads only the preferred audible/legible selection, based on device language and accessibility settings.
3. **Keep the device connected to a network** and open the downloaded content. Observe that many more subtitles and audio tracks are available to pick from.
4. **Enable Airplane mode and disable WiFi** while playing the content.
5. Pick a different audio. Playback incorrectly stalls because the variant is not available offline and the player attempts to load it over the (non-available) network instead.

## Expected results

When playing a downloaded stream only options available locally are presented to the user in the system standard playback UI.

## Actual results

When playing a downloaded stream options presented to the user in the system standard playback UI differ depending on whether the device was online or offline when playback started. This leads to a user experience that can surprise the user in a bad way (data plan consumption, stuck playback).
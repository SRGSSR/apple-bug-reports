# AVFoundation: Offline playback fails due to media selection picking variants declared in the master playlist but not available offline

## Description of the problem

HLS streams downloaded with AVFoundation `AVAssetDownloadURLSession` may not locally contain all audible or legible variants declared by a master playlist.

When playing a downloaded stream offline (e.g. Airplane mode with no WiFi access), media selection performed by `AVPlayer` may incorrectly attempt to load variants declared in the master playlist but not available offline. This makes playback fail with a network error ("The Internet connection appears to be offline") since the player incorrectly attempts to load a variant not available locally from the network instead.

This issue affects all recent OS versions from iOS 16 up to iOS 27 beta 6 (probably earlier ones as well but I could not check).

## How to reproduce the problem

A sample project is attached to this issue. Due to the many pieces required for a complete implementation, I rather started from the official [AVFoundation HLSCatalog  download sample](https://developer.apple.com/documentation/avfoundation/using-avfoundation-to-play-and-persist-http-live-streams) and tweaked it very slightly. Note that this project is sadly not compatible with iOS 27, as it was not updated for scene support. The following changes were made:

- A trailer of "The Morning Show" from Apple TV, with many subtitles and audio variants to pick from, was added to the example list.
- The `AVAssetDownloadConfiguration` was edited to download the German audio track only.
- The `AVAssetDownloadConfiguration` was edited to download a low quality (for faster tests; nothing related to the present issue).

To reproduce the issue:

1. Configure a physical device in **any language except German** and run the sample project.
2. Download "The Morning Show" example (via the info button).
3. **Enable Airplane mode and ensure that no WiFi connection is enabled** either.
4. Tap on "The Morning Show" cell to play the content. Playback incorrectly fails with "The Internet connection appears to be offline" (logged to the Xcode console).

### Root cause

Assume your device language is set to English. In the HLSCatalog example default media selection is used since no `AVPlayerMediaSelectionCriteria` have been set on the player. The player therefore attempts to load English (device language) as preferred audio and finds a reference in the local master playlist saved in the downloaded `movpkg`, without checking that this variant is actually available offline. Since this variant is not available (we downloaded only German audio), the player attempts to load the English audio media playlist from the network instead and fails since no network connection is available.

### Remarks

- If a network connection is available playback succeeds since the player will play German audio from the network. This does not solve the problem and is not an acceptable workaround since users do not expect any data transfer while playing offline content (they also usually do not have access to a network connection).
- The issue is the same when explicitly setting `AVPlayerMediaSelectionCriteria` preferred languages, if the selected variant is declared in the master playlist but not available offline.
- A related issue affects the system player user interface. I will add a link to the relevant FB number in a comment.

## Expected results

Offline playback should just work, even when no network connection is available.

## Actual results

When no network connection is available, offline playback fails due to media selection picking variants declared in the master playlist but not available offline.
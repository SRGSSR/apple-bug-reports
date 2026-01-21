# AVFoundation and FairPlay: AVContentKeySession key request creation fails after several hours

## Description of the problem

We use AVFoundation and `AVPlayer` to play content protected with FairPlay Streaming encryption. Our implementation relies on the modern `AVContentKeySession` API for handling content key retrieval.

> Note: Our DRM provider is Irdeto but we believe this detail is not directly relevant to the issue described below.

We’ve encountered a consistent problem when an app using `AVContentKeySession` remains in the background for several hours without being terminated. Upon resuming the app and attempting to play new DRM-protected content, calling `AVContentKeyRequest.makeStreamingContentKeyRequestData(forApp:contentIdentifier:)` to start the key request process fails with the following error:

```
Error Domain=AVFoundationErrorDomain Code=-11800 "The operation could not be completed" UserInfo={NSLocalizedFailureReason=An unknown error occurred (-42669), NSLocalizedDescription=The operation could not be completed, NSUnderlyingError=0x120c1e880 {Error Domain=NSOSStatusErrorDomain Code=-42669 "(null)"}}
```

This of course makes playback fail as well, with the error reported to the `AVPlayerItem` and its error log without any additional useful information.

> Important: The minimum inactivity duration that triggers this issue is hard to pinpoint, but we usually reproduce it reliably after 24 hours of background inactivity (sometimes less).

The error code **-42669** appearing in the above error message is sadly undocumented and the associated message is too generic to be useful. This code also doesn’t appear in the _FairPlay Streaming Programming Guide_ (section 8-1), Technical Notes, or Apple Developer Forums. However, based on the range and structure of other FairPlay-related codes, this definitely seems to be a FairPlay-specific error.

> Note: We contacted Greg Chiste from Apple DTS who informed us that error code **-42669** should correspond to `AVContentKeyRequestRetryReasonTimedOut`.

Further investigation shows that the failure originates in the `mediaplaybackd` daemon, during a call to `ckb_createRequestData`, which is invoked as part of the content key request creation process.

Due to the fact this error occurs very early in the content key request creation process, we suspect there might be an issue with `mediaplaybackd`itself and the aforementioned internal `ckb`  functions (should be related to some _Content KeyBoss_ internal service according to the logs we captured).

## How to reproduce the problem

A sample project is attached to this issue (the code is also available on [GitHub](https://github.com/SRGSSR/drm-player-poc-apple)). It is a minimal playback app that offers several DRM-protected streams our company provides (livestreams and on-demand content), each with a distinct content identifier. See the attached `demo_overview_play_all` video that shows that each content is playable when played in succession.

> Tip: The demo includes an in-app console that logs events from the content key session delegate, including whether content key retrieval succeeds or fails (and why). This console can be enabled with the button at the top right.

To reproduce the issue:

1. Launch the demo app and play the first stream _RTS1_ (a TV livestream). The content should play successfully (see attached `day_1_play_content_success` video). During this process, a single shared `AVContentKeySession` is instantiated, which is why it is important to play at least one stream. A capture of typical Console logs in this case is available in the attached `success.txt` file.
2. Close the player and send the app to the background. Leave the device idle for approximately 24 hours.
3. After 24 hours, bring the app back to the foreground and attempt to play the second (or third) livestream _SRF1_ (resp. _RSI1_). Playback is now expected to fail with the above error (see attached `day_2_play_other_content_failure` video, which begins with checking that the first content open the day before remains playable). Note that the process is repeated several times, each time ending with a failure. A capture of typical Console logs at the time of the failure is available in the attached `failure.txt` file.

> Tip: Since reproducing the problem takes quite a large amount of time you might want to run the above scenario on several devices in parallel to maximitze your chances.

Any other attempt to play other contents will similarly fail as well. Only the first content remains playable.

> Note: The streams are geoblocked. To access them, you will need to use a VPN and simulate a location in Switzerland. The first three streams in the demo are livestreams that should never expire. The last two are on-demand streams that usually expire after 2 weeks. Please contact us if you need updated URLs.

A sysdiagnose file is included (`sysdiagnose_2025.07.31_07-53-58+0200_iPhone-OS_iPhone_22G86.tar`). Have a look at processes `DRMPlayer` (the app) and `mediaplaybackd` in the logs, around 2025-07-31 07:53:49.720870+0200. Feedback Assistant forced me to include sysdiagnose for another device but please have a look at the aforementioned one.

## Expected results

An app using `AVContentKeySession` that has been sitting in the background for any amount of time can still start new content key requests by calling `AVContentKeyRequest.makeStreamingContentKeyRequestData(forApp:contentIdentifier:)`. No error is returned by `mediaplaybackd`.

## Actual results

An app using `AVContentKeySession` that as been sitting in the background for a sufficiently large amount of time (24 hours e.g.) cannot start new content key requests by calling `AVContentKeyRequest.makeStreamingContentKeyRequestData(forApp:contentIdentifier:)`. An error **-42669** is returned by `mediaplaybackd`.

## Version information

We have reproduced this issue on iOS 18.4, 18.5 and 18.6 devices. We could also reproduce it on iOS 26 beta 4. We are using Xcode 16.4.0 (and 26.0 beta for beta devices).

## Link to DTS support request

This issue was requested following a discussion with Greg Chiste from the DTS team (Case-ID: 15264194).

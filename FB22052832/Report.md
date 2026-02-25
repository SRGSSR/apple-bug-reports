# FairPlay-protected content playback fails with Lightning adapter (A1438) on iOS 18 and above

## Description of the problem

When using an official Lightning-to-HDMI Apple adapter (A1438) to connect a Lightning-equiped iOS device to a screen, using an appropriate HDMI cable, playback always fails with a -12035 CoreMedia error when playing FairPlay protected content on iOS 18 and 26. Non-protected content plays just fine.

Note that:

- Using the same adapter, the same HDMI cable and the same content, FairPlay playback succeeds with older devices running iOS 17 or iOS 15. This therefore suggests a regression introduced with iOS 18 and support for this specific kind of adapter.
- Our FairPlay DRM provider is Irdeto. Our configuration allows adapters and AirPlay (see attached screenshot) and our configuration uses the default HDCP protection level (Type 0).
- We could check with Irdeto that there are no errors during the license acquisition process.
- FairPlay-protected content plays fine with an iOS 26 device when using a USB-C-to-HDMI (A2119) adapter with an iOS 26 device supporting USB-C.
- FairPlay-protected content plays fine with an iOS 26 device when using a USB-C cable to connect an iOS 26 device supporting USB-C directly to a screen, without Apple adapter.
- We tested various TVs or computer screens as well as several hi-speed HDMI cables. Results are consistent.
- The error happens when starting playback with the adapter already connected, but also when the adapter is connected during playback.

### Version information

- Lightning Adapter: A1438, firmware version 8.0.0 (14A7040), hardware version 1.0.0.
- Affected test devices: iPhone XS running iOS 18.7.3 and iPhone 14 Pro running iOS 26.3.

### Additional technical context

We could confirm with Irdeto that FairPlay licenses are successfully issued in all scenarios. No DRM policy, entitlement, or license response differs between Lightning and USB‑C cases.

- HDCP enforcement appears to occur after license acquisition, during the external output path.
- The DRM server applies default HDCP restrictions.

This suggests the behaviour may be related to iOS external display handling or connector-specific enforcement.

### Key questions

1. Is external playback of FairPlay Streaming–protected content over Lightning‑to‑HDMI intentionally restricted or deprecated on recent iOS versions?
2. Have there been changes in iOS 18 or later affecting HDCP or external display handling for Lightning adapters?
3. Are there additional HDCP or adapter requirements specific to Lightning that differ from USB‑C?
4. Is this behaviour expected, or should it be treated as a potential issue/regression?

## How to reproduce the problem

Note that our FairPlay protected streams are geoblocked. You should use a VPN with location set to Switzerland (some VPNs might be detected and blocked as well, so be careful with the initial setup):

1. Download our "Pillarbox demo" application from [TestFlight](https://testflight.apple.com/join/TS6ngLqf) on an iOS 26 device equiped with a Lightning port. This is a demo for our AVFoundation-based player SDK, whose code is [public](https://github.com/SRGSSR/pillarbox-apple).
2. Connect the device to a TV screen using a combination of a Lightning-to-HDMI adapter (A1438) and a suitable HDMI cable.
3. Under the "Lists" tab, tap on "TV Livestreams", then play "RTS Couleur 3 en direct" (non-protected stream). The image should appear on the TV.
4. Close the player with a swipe down and play "RTS 1" (FairPlay-protected stream). Playback should fail, with mirroring freezing in the process. The adapter must be disconnected and connected again for mirroring to resume.

If you repeat scenario the same with an iOS 17 device you can observe that FairPlay-protected content plays just fine, suggesting a regression.

## Expected results

When using a Lightning-to-HDMI adapter (A1438) with a device running iOS 18 or iOS 26, playback of FairPlay-protected content fails.

## Actual results

When using a Lightning-to-HDMI adapter (A1438) with a device running iOS 18 or iOS 26, FairPlay-protected content plays just fine.
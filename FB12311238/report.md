# Sound Leakage Issue with Multiple Video Players Using AirPlay (FB12311238)

## Description

When two videos are playing simultaneously, 
one using AirPlay and the other on an iOS device, 
both videos can be heard on the Apple TV, 
even if the second one is muted.

## Steps to Reproduce

1. Open the demo app.
2. Send one of the streams to AppleTV via AirPlay.
3. Pause the video sent via AirPlay.

## Expected Result

The second video should not produce any sound.

## Actual Result

The second video can be heard even if it's not muted.

## Configuration

- OS Version: iOS 16.3.1 & tvOS 16.5
- Device: iPhone 13 Pro
- Xcode Version: 14.3.1
- [Code Reproducing the Bug](https://github.com/waliid/issues/tree/main/AirplaySoundLeakDemo)

# Remarks

This behavior cannot be reproduce on tvOS 16.1.

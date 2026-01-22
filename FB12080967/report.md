# AVPlayerItem.presentationSize & AirPlay (FB12080967)

## Description

The property `AVPlayerItem.presentationSize` is always equal to zero when `AirPlay` is activated.

## Steps to Reproduce

1. Open the demo app
2. Send the stream to an AirPlay device
3. Play the audio or the video stream.

## Expected Result

The value of `presentationSize` should reflect the actual size of the video being played.

## Actual Result

The value of `presentationSize` is always equal to zero when AirPlay is activated.

## Configuration

- OS Version: iOS 16.3.1
- Device: iPhone 13 Pro
- Xcode Version: 14.2.0
- [Code Reproducing the Bug](https://github.com/waliid/issues/tree/main/PresentationSizeDemo)
- Video showing how to reproduce: [Link](https://github.com/waliid/issues/raw/main/PresentationSizeDemo/airplay.mp4)

# Remarks

When AirPlay is activated nothing is presented on my device.
In the aboslut the behavior does not shock me. But I wonder if it's a bug or if it's a normal behavior.
If it is the case and it is a normal behavior how can we determine the type of stream (audio or video)?
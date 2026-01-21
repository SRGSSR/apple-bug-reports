# AVPlayerItem `tracks` property is sometimes empty when using Airplay

## Area
AVFoundation (Audio / Video)

## Summary
When Airplay is used, the AVPlayerItem `tracks` property (an array) is empty if Airplay was enabled before playback starts. If Airplay is enabled after playback has started (e.g. using the Control Center dedicated button), then track information is available.

This issue also affects older iOS versions (tested on iOS 8 for example) and is probably not a regression.

Steps to Reproduce:

1. Open the project supplied as file attachment. This project uses the standard AVPlayerViewController for playback of an HLS test stream
2. Build and run the project from Xcode on a device connected to a wifi network. Ensure that an Airplay receiver (e.g. Apple TV) is available on the same network
3. Tap on the Play video button of the application. This starts video playback. Check the Xcode console, where the contents of the tracks property is displayed (two tracks are available in the test stream)
4. Now enable Airplay and send the video stream to the Airplay receiver. Check the Xcode console, you can see that both tracks remain available
5. Close the player, and open it again without disconnecting Airplay. Now check the Xcode console again, the tracks array is now empty
6. If you now switch off Airplay while the video is still being played, the two tracks will appear again in the Xcode console

## Expected Results

I expect a consistent behaviour in all cases, whether Airplay was enabled or not before playback started. Track information should be always available during playback.

## Actual Results

If Airplay playback was enabled before playback started, no track information is available.

## Version

iOS 9.3.2

## Notes

Configuration:
iPhone 6S, Wifi

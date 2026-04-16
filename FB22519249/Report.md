# AVPlayerItem access log: Incorrect metrics after audio track switch

## Description of the problem

Key metrics about a playback session can be gathered from `AVPlayerItemAccessLog`. Each event contained in the log collates data related to an uninterrupted period of playback (see official [documentation](https://developer.apple.com/documentation/avfoundation/avplayeritemaccesslog)). The last event is updated in-place and frozen when a new event is inserted, usually after a seek operation or a variant switch.

At any time the entire access log can be extracted from an `AVPlayerItem` in textual form (W3C Extended Log File Format) for inspection, for example:

```
#Software: AppleCoreMedia/1.0.0.23F5054h (iPad; U; CPU OS 26_5 like Mac OS X; en_us)
#Date: 2026/04/15 15:14:02.002
#Fields: date time uri cs-guid s-ip s-ip-changes sc-count c-duration-downloaded c-start-time c-duration-watched bytes c-observed-bitrate sc-indicated-bitrate c-stalls c-frames-dropped c-startup-time c-overdue c-reason c-observed-min-bitrate c-observed-max-bitrate c-observed-bitrate-sd s-playback-type sc-wwan-count c-switch-bitrate
2026/04/15 15:13:26.026 https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear5/prog_index.m3u8 2D5C8F04-9F34-40F2-AA06-758CE4EC3643 17.253.122.203 0 26 399.556 0.000 10.181 42231947 23666383.000 1924009 0 0 0.133 0 8 - - 6122725.443 VOD 0 -
- - https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear5/prog_index.m3u8 2D5C8F04-9F34-40F2-AA06-758CE4EC3643 - - 0 0.000 0.000 0.000 0 22814446.000 1924009 0 0 0.040 0 - - - 6124945.832 VOD 0 -
2026/04/15 15:14:01.001 https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear5/prog_index.m3u8 2D5C8F04-9F34-40F2-AA06-758CE4EC3643 17.253.122.203 0 3 69.943 160.160 0.187 3804746 21217859.000 1924009 0 0 2.093 0 - - - 7690171.329 VOD 0 -
```

Some values can be read as is (e.g. bandwidth values, IP addresses) but other values are cumulative, as explained in a [WWDC session](https://nonstrict.eu/wwdcindex/wwdc2018/502/).

Among these cumulative values are:

- `bytes`: Number of bytes transferred, readable from `AVPlayerItemAccessLogEvent.numberOfBytesTransferred`
- `sc-count`: The number of media requests, readable from `AVPlayerItemAccessLogEvent.numberOfMediaRequests`

For some reason, when the audio track of a video is switched, we noticed that these two cumulative values (and possibly other such values) briefly get wrong. This can either be observed:

- In the current event (last one in the list) metrics, updated with values smaller than they were before.
- In a recently frozen event (penultimate event in the list), whose metrics are updated with values smaller than they were before.

As a result, regularly plotting the difference between two summed key metrics leads to incorrectly negative increments (see attached `plot_example.png` screenshot for an example). Such values should namely only increase over time.

### Remarks

This issue was reproduced on iOS 26.4 and 26.5 beta 2 but also on older iOS versions (e.g. on iOS 17).

## How to reproduce the problem

A sample project is attached to this issue. This project simply plays a multi-audio sample stream (Apple Bip Bop) and provides a button which can be used to print the current access log (in Extended Log File Format) at any time to the console.

To reproduce the issue:

1. Run the project on an iOS device. The stream starts playing.
2. Seek a few times in the stream to generate a few log events, then pause playback (not mandatory but convenient).
3. Tap on the "Print access log" button to dump the access log. Capture it.
4. Now use the settings to change the audio track. Then tap on the "Print access log" button again to dump the new access log. Capture it as well.

Compare the logs, e.g. with a diff tool. You can observe that either:

- The number of log events is the same after the switch, but `bytes` and `sc-count` values are smaller than before. Compare for example the attached `log_before_audio_switch.txt` and `log_after_first_audio_switch.txt` captured after a first audio switch (check `missing_in_current_event.png` for a visual diff).
- The number of log events has increased, but the last frozen values are smaller than before. Compare for example the attached `log_after_first_audio_switch.txt` and `log_after_second_audio_switch.txt` captured after a second audio switch (check `missing_in_recently_frozen_event.png` for a visual diff).

## Expected results

Key metrics obtained from an `AVPlayerItemAccessLog` are correct. In particular, cumulative values (e.g. transferred bytes or number of requests) calculated from the access log are never smaller than the cumulated values calculated from the same access log at a later time.

## Actual results

Key metrics obtained from an `AVPlayerItemAccessLog` are not correct just after an audio track switch. In particular, some cumulative values (e.g. transferred bytes or number of requests) calculated from the access log are smaller after the audio switch than before the switch.
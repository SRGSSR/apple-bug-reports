# `AVAssetDownloadURLSession`: Persist AES-128 keys for offline playback

## Description of the problem

 When HLS streams are downloaded using `AVAssetDownloadURLSession`, they are saved to a local `movpkg` folder containing:

- The relevant master and media playlists (including playlists for alternative audio tracks or subtitles).
- Associated media segments.
- XML manifest files that describe the package.

For AES-128 encrypted content, though, the local package does not contain any keys to be used for decryption, and relevant entries in HLS playlists (`EXT-X-SESSION-KEY` and `EXT-X-KEY`) still point at the original URI. As a result such `movpkg`s are not playable without any network connection, which defeats the purpose of downloading them for offline consumption.

## How to reproduce the problem

1. Download the [AVFoundation offline playback HLSCatalog sample](https://developer.apple.com/documentation/avfoundation/using-avfoundation-to-play-and-persist-http-live-streams) from Apple's website.
2. Edit `Streams.plist` to add the following AES-128 encrypted stream: https://playertest.longtailvideo.com/adaptive/oceans_aes/oceans_aes.m3u8
3. Run the demo on a physical iOS device and download the aforementioned AES-128 stream (note that the HLSCatalog project was not updated for scene support, you should therefore run it on iOS 26 or earlier).
4. Once the stream has been downloaded, play it while the device is still online. Playback succeeds.
5. Go offline and try to play the downloaded content once more. Playback now fails (Error Domain=NSURLErrorDomain Code=-1009 "The Internet connection appears to be offline.").

For convenience a copy of the HLSCatalog sample app including the above stream (and other streams listed below) is attached to this issue.

## Explanation

The media playlist associated with the above stream and saved to the `movpkg` looks as follows:

```
#EXTM3U
#EXT-X-VERSION:1
#EXT-X-MEDIA-SEQUENCE:1
#EXT-X-ALLOW-CACHE:NO
#EXT-X-TARGETDURATION:11
#EXT-X-KEY:METHOD=AES-128,URI="oceans.key"
#EXTINF:11, no desc
oceans_aes-audio=65000-video=2042000-1.ts
...
```

The `oceans.key` is not available locally. The stream plays fine when still online (as the key can still be downloaded from the network based on information available from the `movpkg`) but when offline it attempts to retrieve it from the network and fails with a corresponding error (Error Domain=NSURLErrorDomain Code=-1009 "The Internet connection appears to be offline.").

### Possible solution

When an AES-128 encrypted HLS stream is downloaded using `AVAssetDownloadURLSession`, keys declared with `EXT-X-SESSION-KEY` and `EXT-X-KEY` tags could be downloaded and inlined directly as data URIs replacing the original URIs. For example the above playlist would be saved locally as:

```
#EXTM3U
#EXT-X-VERSION:1
#EXT-X-MEDIA-SEQUENCE:1
#EXT-X-ALLOW-CACHE:NO
#EXT-X-TARGETDURATION:11
#EXT-X-KEY:METHOD=AES-128,URI="data:application/octet-stream;base64,AAAAAAAAAAAAAAAAAAAAAA=="
#EXTINF:11, no desc
oceans_aes-audio=65000-video=2042000-1.ts
...
```

with `AAAAAAAAAAAAAAAAAAAAAA==` the correct Base 64 representation of the downloaded key.

Note that this solution can actually be implemented at the application level already but it might make sense to be implemented within `AVFoundation` directly, provided there is no problem with this approach of course.

### Remark

URIs can be absolute or relative, which means that the following key URIs

```
URI="oceans.key"
URI="https://myserver.com/oceans.key"
URI="//myserver.com/oceans.key"
URI="../aes128/oceans.key"
```

should be supported.

## Sample streams

Here are a few AES-128 encrypted streams currently available online (those might expire, though, you should test them first):

- https://cdn.bitmovin.com/content/internal/assets/art-of-motion_drm/m3u8s/11331.m3u8
- https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel-multikey-cenc.ism/.m3u8
- https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel-aes.ism/.m3u8
- https://playertest.longtailvideo.com/adaptive/oceans_aes/oceans_aes.m3u8
- https://playertest.longtailvideo.com/adaptive/aes-with-tracks/master.m3u8

These streams provide keys with different configurations that should all be supported (at the master/media playlist level, with absolute or relative URIs).

## Expected results

HLS AES-128 encrypted streams downloaded using `AVAssetDownloadURLSession` can be played offline. In particular all above streams (if still downloadable) play offline successfully.

## Actual results

HLS AES-128 encrypted streams downloaded using `AVAssetDownloadURLSession` cannot be played offline.

# Media playback errors in CoreMediaErrorDomain lack context and documentation

Description of the problem:
---------------------------

Errors related to media playback, whether received from AVPlayer directly or read from an AVPlayerItem access log, typically lack the contextual information necessary to diagnose playback issues.

Most playback errors originate from the CoreMediaErrorDomain, and while tools like mediastreamvalidator and ffmpeg can sometimes assist, it remains difficult to pinpoint the root cause — especially when the failure is content-related (e.g. invalid encoding, playlist issues, or DRM restrictions).

The lack of documentation and meaningful error descriptions makes troubleshooting cumbersome and often speculative.

Remark: I opened the issue for iOS but this issue is relevant for all platforms.


Examples:
----------

Here are typical playback errors from the CoreMediaErrorDomain:

- Error Domain=CoreMediaErrorDomain Code=-12927 "(null)"
- Error Domain=CoreMediaErrorDomain Code=-16012 "(null)"
- Error Domain=CoreMediaErrorDomain Code=-12685 "The operation couldn’t be completed."

These errors:

- Frequently have no message.
- When a message is present, it provides no actionable insight.
- Error codes themselves are undocumented.


Suggestions:
-------------

To improve developer experience and troubleshooting efficiency, consider:

- Exposing a public constant for the CoreMediaErrorDomain domain.
- Documenting public constants for known error codes within this domain.
- Associating each error with a meaningful, human-readable description to clarify the nature of the issue (e.g. “DRM license missing”, “unsupported codec”, “malformed playlist”).

If comprehensive improvements aren’t feasible in the short term, at a minimum:

- Publish a documented list of possible error codes for CoreMediaErrorDomain, along with typical causes and suggested troubleshooting steps. For reference, an example of this type of documentation can be found at osstatus.com.


Expected results:
-----------------

Playback-related errors should be understandable and actionable, making it possible to quickly identify whether a failure is due to encoding problems, DRM issues, or other content-related errors.


Actual results:
---------------

Playback errors are currently undocumented, opaque, and difficult to interpret, limiting their usefulness during development, debugging, monitoring and troubleshooting.

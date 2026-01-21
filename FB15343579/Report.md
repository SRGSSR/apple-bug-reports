# AirPlay does not work in iPad applications run on macOS

Description of the problem:
---------------------------

Even if an iPad app correctly implements AirPlay, AirPlay does not work when this iPad app is run on macOS.


How to reproduce the problem:
-----------------------------

A simple sample project is attached to this issue. This iOS / iPadOS app presents an AVKit `VideoPlayer` and is enabled for AirPlay. Very basic playback error logging is also implemented.

To reproduce the issue:

1. Open the attached sample project and run it with the "My Mac (Designed for iPad)" destination.
2. Enable AirPlay with a receiver available on your network. Playback never resumes on the AirPlay receiver and you can observe an error logged to the console (filter log output with "-->"). The system player UI does not display any error and remains stuck (see attached screenshot). If AirPlay is disconnected playback resumes on the casting Mac computer.

The logged error is quite vague:

--> Failed to play to end time: Error Domain=AVFoundationErrorDomain Code=-11870 "The operation could not be completed" UserInfo={NSLocalizedFailureReason=An unknown error occurred (-16746), NSLocalizedDescription=The operation could not be completed, NSUnderlyingError=0x600001307c60 {Error Domain=NSOSStatusErrorDomain Code=-16746 "(null)"}}

If the project is run on an iPad device the behavior is just fine.

Setup: Xcode 16, macOS 15.0.


Expected results:
-----------------

AirPlay works with iPad apps run on macOS.


Actual results:
---------------

AirPlay does not work with iPad apps run on macOS.


Update 1:
---------

As i(Pad)OS app developers we often face 3rd party dependencies that we have no control of (difficulty to make feature requests, no access to source code), that we are forced to use by business people, and whose maintainers have no time or intention to add native macOS support to.

If you want to deliver an existing i(Pad)OS app using such 3rd party dependencies to macOS users, therefore extending the reach of your product, you have two options:

- You enable macOS as a deployment target and isolate 3rd party dependencies not available on macOS (via project configuration / preprocessor) so that the app can run on macOS, albeit with a possibly degraded experience.
- You deliver your app as iPad app on macOS, making surgical improvements to better improve its integration with macOS.

I have published a (supposedly awesome) video player library on GitHub (https://github.com/defagos/MobileVideoLibraryFB15343579) as an example. Let us assume that this library is supplied by a renown 3rd party provider, that business people are forcing you to use in your video app, and that this library does not support macOS directly, only i(Pad)OS. You must consider this code as read-only and outside your control.

The library itself covers all the needs you might have as a video player app developer. In particular it supports AirPlay and, in one of its ready-to-use video player user interface layouts, displays an associated button when appropriate.

I have updated my original sample project (the update is attached to this comment) to use this video player library I published on GitHub. Let us assume this dependency is essential. If you now want to extend the sample i(Pad)OS app to macOS you are basically stuck:

- If you run the app as iPad app on macOS the AirPlay button will be available but switching routes fails (the player layout is implemented in the library and you cannot change it). The user experience is poor.
- If you attempt to update the Xcode project to support macOS you cannot build it anymore, as you cannot remove the video player library dependency (it is essential to the app) and it does not support macOS.

I originally opened this issue since I am myself developing a video playback library, and this is the kind of issue that I face to extend the platform reach of my library. My original sample project was probably too simple in this regard. I hope that the updated code sample update lets you better understand the suggestion I made before:

"Since `AVRoutePickerView` lets a user pick a route with no result in iPad apps running on macOS or using Catalyst, wouldn't it be better to not display the route button on such platforms?"
# iOS 26 regression: `Menu` interactions are erratic when a menu is embedded in a view that is often refreshed

Description of the problem:
---------------------------

A `Menu` might be displayed by a parent view that is refreshed quite often (e.g. a view containing a slider and a settings menu, refreshed every 1/10th second during playback of an associated video player).

Prior to iOS 26 such menus were working properly.

Starting with iOS 26, though, frequently refreshed menus erratically respond to user interactions, sometimes correctly taking the interaction into account, most of the time ignoring it.

### Remark

In the example above the view hierarchy should of course be revisited to have only the slider refreshed every 1/10th second and the menu not refreshed unnecessarily. This would probably be the best solution (and an obvious better design) but the fact `Menu` behaved in a more robust way prior to iOS 26 might pique your interest.


How to reproduce the problem:
-----------------------------

A sample app is attached to this issue. This app displays a Unix timestamp, refreshed every 1/10th second. A `Menu` is displayed on the same view, with 3 available items to select. A library (https://github.com/KaneCheshire/ShowTime.git) has been added to make touch interactions visible.

To reproduce the issue:

1. Build and run the application on an i(Pad)OS 18 device. Open the menu and select an item. Observe that your interaction with the menu succeeds and is not interrupted. Repeat several times and observe this behavior is consistent.
2. Now do the same, but on an i(Pad)OS 26 device. Observe that selection of an item often does not work, with the menu responding to user interaction but not selecting anything or closing.

Two videos are attached to this issue to illustrate these observed behaviors. My test setup is:

- An iPad Air 5th gen running iOS 18.6.
- An iPad Pro 3rd gen running iOS 26.2 beta (but the issue can be reproduced on devices running iOS 26.0 or 26.1, e.g. on my iPhone 14 Pro running iOS 26.1).
- Xcode 26.1

### Remark

If the refresh rate is lowered to 1 second the menu works correctly on i(Pad)OS 26.


Expected results:
-----------------

`Menu` always responds correctly to user interactions, even when embedded in a parent view that is refreshed often.


Actual results:
---------------

On i(Pad)OS 26 `Menu` often ignores user interactions when embedded in a parent view that is refreshed often.
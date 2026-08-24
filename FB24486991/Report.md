# iOS 27 regression: Objects whose properties are bound to items displayed in a `Menu` are not correctly deallocated

## Description of the problem

A `Menu` can for example be a good approach to select among different properties of a bound object. For example a settings menu can be a convenient way to select among playback speeds or the subtitles associated with a media player.

Starting with iOS 27, though, a regression in how `Menu` behaves prevents objects whose properties are bound to contained menu items from being correctly deallocated.

### Remarks

- Tested with Xcode 27 beta 5 and iOS 27 beta 6.
- This issue affects `@Observable` and `ObservableObject` in the same way.
- The issue is assigned to iOS 27 seed 5 but affects beta 6 as well.

## How to reproduce the problem

A small sample app is attached to this bug report. This app contains:

- A `Player` observable type. This player has a single playback speed property. Its `deinit` method prints a message to the console when called.
- A modal view which owns a player instance and displays a menu from which the current playback speed can be chosen.

You can use this project to compare the behaviors between iOS 26 (or earlier) and iOS 27.

### iOS 26 and earlier

1. Run the sample app on a physical iOS 26 device or with the iOS 26 simulator.
2. Tap on the "Show modal" button. Close the modal and observe that the associated `Player` is correctly deallocated.
3. Tap on the "Show modal" button again, then open menu and close it (e.g. by choosing another speed). Close the modal and observe that the associated `Player` is correctly deallocated.

A video of the above steps is attached to this issue (demo_ios_26.mp4).

### iOS 27 beta 6

1. Run the sample app on a physical iOS 26 device.
2. Tap on the "Show modal" button. Close the modal and observe that the associated `Player` is correctly deallocated.
3. Tap on the "Show modal" button again, then open menu and close it (e.g. by choosing another speed). Close the modal and observe that the associated `Player` is not deallocated

A video of the above steps is attached to this issue (demo_ios_27.mp4).

## Expected results

Objects bound to `Menu` items are never prevented from being immediately deallocated once they are not needed anymore.

## Actual results

On iOS 27, objects bound to `Menu` items are not correctly deallocated once not needed anymore. This was not the case on iOS 26 and before.

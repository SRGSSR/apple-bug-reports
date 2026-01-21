# iOS 26 regression: Slider fine-grained adjustments gesture does not work reliably anymore

Description of the problem:
---------------------------

Starting with iOS/iPadOS 26, the usual "double-tap and slide horizontally to adjust the value" gesture associated with a slider does not work reliably anymore (the value cannot be adjusted and the slider knob remains stuck). This affects vanilla sliders with the new Liquid Glass knob appearance appearing in the Settings app, for example:

- The screen _Brightness_ slider.
- The _Ringtone and Alerts_ volume slider.

Some other sliders do not seem affected, e.g. the _Speaking Rate_ VoiceOver setting slider but, more generally, a simple `Slider` added to a SwiftUI app is not accessible with the standard gesture either:

```swift
import SwiftUI

struct ContentView: View {
    @State private var value: Float = 0

    var body: some View {
        Slider(value: $value)
            .padding()
    }
}

#Preview {
    ContentView()
}
```

The only workaround is to use swipe up/down gestures to adjust the slider value in larger increments.


How to reproduce the problem:
-----------------------------

1. Open the Settings app on an iOS or iPad OS 26 device.
2. Locate one of the sliders mentioned above.
3. Enable VoiceOver.
4. Focus on the slider, tap twice in quick succession and hold, then swipe horizontally to adjust the value. The slider knob remains stuck.

If you  repeat the same with an iOS 18 device the behavior is fine.

Test setup:

- iOS 26.0.1 on iPhone 14 Pro
- iPadOS 26.1 beta 4 on iPad Pro 11-inch (3rd gen).


Expected results:
-----------------

Using VoiceOver on iOS 26, the value of a slider can always be adjusted with a "double-tap and slide horizontally to adjust the value" gesture.


Actual results:
---------------

Using VoiceOver on iOS 26, the value of a slider cannot be reliably adjusted with a "double-tap and slide horizontally to adjust the value" gesture. This includes some sliders in the Settings app, but also simple SwiftUI `Slider`s added to apps.

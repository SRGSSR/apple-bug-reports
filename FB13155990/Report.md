# SwiftUI Menu API: Add initializers offering a binding to the menu visibility state

Context
--------

SwiftUI provides a `Menu` API to build context menus declaratively. One peculiarity of the `Menu` API, though, is that `onAppear` action is only called once when the menu is displayed for the first time. For the same reason `onDisappear` action is not called when the menu is closed by the user (either by tapping outside the menu or picking an item). This makes it impossible to build experiences that rely on the menu visibility state to be known.

One such example is a player user interface, like the one AVKit provides with `VideoPlayer`. Player controls, which automatically hide during playback, offer a settings button opening an associated menu, likely implemented with UIKit. When the menu is opened player controls are prevented from hiding automatically, which guarantees that the menu is always properly anchored to its origin button, ensuring the user experience stays consistent.

This behavior sadly cannot be implemented in SwiftUI, though, since there is no way to know when the menu is visible to the user. The following proposal intends to fill this gap.


Proposal
---------

SwiftUI `Menu` should provide initializers supporting a binding to a Boolean presentation state, most likely:

```swift
public extension Menu {
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label)

    init(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) where Label == Text

    init<S>(_ title: S, isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) where Label == Text, S : StringProtocol
}
```

This way implementations would be able to retrieve and programmatically control menu visibility, e.g. via a binding to a corresponding `@State` property. In the player UI example above, the presentation state could then be used to prevent controls from being automatically hidden while the menu is visible.

Thank you very much in advance for considering this API improvement proposal.

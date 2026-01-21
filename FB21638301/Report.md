# `ContentUnavailableView` may lead to unnecessary re-creation of state associated with views it embeds

Description of the problem:
---------------------------

`ContentUnavailableView` may lead to unnecessary re-creation of state associated with views it embeds. This is a problem, e.g. if this state is a view model which should only be instantiated sparingly when a view is actually created.

Consider the following content view:

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            ContentUnavailableView {
                TimeView()
            }
            Text("Some text")
        }
    }
}

#Preview {
    ContentView()
}
```

where `TimeView` is a view displaying the current time, backed by a view model stored as a `@StateObject`. We can observe that `ContentView` body refreshes occur every second, with the state associated with `TimeView` created again. This behavior is surprising, unexpected and ultimately dangerous.

Also note that, even if the state is created again, `onAppear` and `onDisappear` are not called in between re-creations. The view therefore does not seem re-created, only its state is.

### Environment

- Xcode 26.2
- iOS 17 to iOS 26.2

### Remark

The behavior of the above code is correct if:

- Replacing `ContentUnavailableView` with `ZStack`. This clearly associates the issue with `ContentUnavailableView`.
- Removing the `Text` in the `VStack`, which suggests the issue might be related to some redrawing pass induced by `ContentUnavailableView`.


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. This sample project implements the above example, with a `TimeView`, wrapped in a `ContentUnavailableView` and backed by a view model, displaying the current time.

The following events are logged to the console:

- Time view model initialization.
- Time view appearance/disappearance.

To reproduce:

1. Run the sample project on a device or in the simulator (e.g. iOS 26.2).
2. Look at the logs. You can observe that the view model is incorrectly initialized every second while the view is visible.

You can also try the two alternative content views whose code is commented out in the demo (one with `ZStack` instead of `ContentUnavailableView`, the other without sibling `Text`) and observe that the behavior in these two cases is correct.

### Remark

A video is attached to this issue as well. You will observe the above use case and that simply commenting out the sibling `Text` view fixes the issue.


Expected results:
-----------------

`ContentUnavailableView` never unnecessarily forces state re-creation for views it embeds.


Actual results:
---------------

`ContentUnavailableView` may force state re-creation for views.

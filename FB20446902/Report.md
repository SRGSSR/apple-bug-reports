# Access to SwiftUI environment in nested modals crashes in iPad apps run on macOS

Description of the problem:
---------------------------

Given an iPad app:

- Presenting a modal sheet C from another modal sheet B, itself presented from a root view A.
- Attaching an `Observable` object (or `@ObservableObject`) O to A's environment and retrieving it from modals B and C.

When the iPad app is run on macOS ("Designed for iPad" run destination), modal presentation of B crashes with the following error (note that "TestContext" is the object associated with the environment, as defined in the sample code attached to this issue):

```
SwiftUICore/Environment+Objects.swift:34: Fatal error: No Observable object of type TestContext found. A View.environmentObject(_:) for TestContext may be missing as an ancestor of this view.
```

The crash is similar when using `ObservableObject`/`@EnvironmentObject`:

```
SwiftUICore/EnvironmentObject.swift:93: Fatal error: No ObservableObject of type TestContext found. A View.environmentObject(_:) for TestContext may be missing as an ancestor of this view.
```

### Remarks

- The crash does not occur when the app is run on an iPad device or in the iPad simulator.
- The crash was reproduced both on macOS 15 and macOS 26, but likely affect older versions as well. This is therefore not a macOS 26 regression.
- There is no crash if modal C is removed and only B is presented from A.


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue, implementing the view hierarchy described above. To reproduce:

1. Adjust code signing settings properly.
2. Run the app on an iPad device or in the iPad simulator.
3. Tap on the "Show sheet" button. A modal is correctly displayed.
4. Now run the app as iPad app on macOS ("Designed for iPad" run destination).
3. Tap on the "Show sheet" button. The app crashes with the error mentioned above (see attached video).


Expected results:
-----------------

Accessing the SwiftUI environment in nested modals never crashes.


Actual results:
---------------

Accessing the SwiftUI environment in nested modals crashes in iPad apps run on macOS ("Designed for iPad" run destination).
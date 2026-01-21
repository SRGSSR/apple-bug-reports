# Add support for priority over system behavior to SwiftUI keyboard shortcuts APIs

Description of the problem:
---------------------------

Version: iPadOS 17.5.1

SwiftUI provides `keyboardShortcut` modifiers to associate a keyboard shortcut with a user interface control. Unlike UIKit `UIKeyCommand` which provides a `wantsPriorityOverSystemBehavior` property, it is currently not possible to assign a shortcut a higher priority than the system behavior with the SwiftUI `keyboardShortcut` API. As a result some shortcuts (e.g. left arrow / right arrow to implement standard skip backward / forward shortcuts for a video player UI) are not possible to implement in SwiftUI, at least not in a way that make them usable on all platforms.

I therefore suggest that `keyboardShortcut` APIs should be enhanced to support `wantsPriorityOverSystemBehavior` somehow (additional parameter or modifier perhaps, but you better know).

Remark: Arrow shortcuts work when running a SwiftUI app as an iPad app on macOS, though.


How to reproduce the problem:
-----------------------------

A sample project has been attached to this issue. This simple project provides two buttons to increment / decrement a value with the arrow keys:

1. Build and run the project on iPadOS.
2. Use the left and arrow keys. Nothing happens.


Expected results:
-----------------

Using the arrow keys increment or decrement values correctly when running the attached sample project.


Actual results:
---------------

Using the arrow keys increment or decrement values does nothing when running the attached sample project.

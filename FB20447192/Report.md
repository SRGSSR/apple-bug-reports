# SwiftUI popovers: Views should be able to determine from their environment whether they are displayed in a popover or modal sheet

Description of the problem:
---------------------------

As described in [Apple's Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/popovers#Best-practices) popover best practices:

> Use a Close button for confirmation and guidance only. A Close button, including Cancel or Done, is worth including if it provides clarity, like exiting with or without saving changes. Otherwise, a popover generally closes when people click or tap outside its bounds or select an item in the popover. If multiple selections are possible, make sure the popover remains open until people explicitly dismiss it or they click or tap outside its bounds.

On iPadOS a popoover displayed using the `popover` modifier can either be displayed as a true popover or as a modal sheet, depending on the available screen space. 

As of iOS 26 there is currently no reliable API for a view embedded in a popover to determine which kind of presentation has been currently adopted by a popover, though (size classes are not a reliable way to determine which presentation is likely). It is therefore unnecessarily difficult to implement the above best practices, e.g. by showing a Close button only when the popover is displayed as a modal sheet but not as an actual popover.

I therefore suggest the addition of the type of popover presentation (if any) to the SwiftUI view environment. This way any view would be able to determine its presentation context and adjust its layout accordingly. 


Rough API idea:
-----------------

We could imagine having the presentation type provided as an enum:

```swift
enum PopoverPresentation {
    case none
    case sheet
    case popover
}
```

and retrieved through the environment, in a way similar to other properties (e.g. size classes):

```swift
struct EmbeddedView: View {
    @Environment(\.popoverPresentation) private var popoverPresentation

    var body: some View {
        switch popoverPresentation {
        case .sheet:
            // ...
        case .popover:
            // ...
        }
    }
}

struct ParentView: View {
    @State private var isPresented = false

    var body: some View {
        // ...
            .popover(isPresented: $isPresented) {
                EmbeddedView()
            }
    }
}
```

This way the `EmbeddedView` can adjust its content based on the type of presentation.
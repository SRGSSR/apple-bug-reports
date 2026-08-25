# Empty submenus should be consistently hidden on all platforms

## Description of the problem

SwiftUI `Menu`s can be nested to create rich menus organized in top-level menus and submenus. Submenus are often dynamic, e.g. a media player settings menu might offer submenus to select subtitles or audio tracks if available. If no options are offered users usually expect submenus to be hidden from view.

Empty submenus behave differently on iOS, tvOS and macOS (either native app or iPad app running on macOS):

- On iOS and tvOS empty submenus are hidden automatically (see attached ios.png and tvos.png screenshots).
- On macOS empty submenus stay visible, though no items are displayed (see attached macos.png screenshot).

Since empty menus are confusing for users, the macOS behavior should be aligned on the iOS and tvOS behavior so that empty submenus are consistently hidden on all platforms.

### Remark

This issue is not new and can be reproduced on all recent major macOS versions.

## How to reproduce the problem

A sample project is attached to this issue. This project displays a menu with two submenus:

- One submenu filled with 10 items.
- One empty submenu.

The code is fairly straightforward:

```swift
struct ContentView: View {
    var body: some View {
        Menu {
            Menu {
                ForEach(1..<10) { i in
                    Text("Item \(i)")
                }
            } label: {
                Text("Filled")
            }
            Menu {
                ForEach(0..<0) { i in
                    Text("Item \(i)")
                }
            } label: {
                Text("Empty")
            }
        } label: {
            Text("Menu")
        }
    }
}
```

To reproduce the issue, just run the app on iOS 26, tvOS 26 and macOS 26 and tap on the _Menu_ button. You'll obtain the results seen in the attached screenshots.

## Expected results

Submenus created with `Menu` are automatically hidden when empty.

## Actual results

On macOS empty submenus are visible, which leads to confusion.

# NavigationStack & Sheet (FB12034450)

## Description

Presenting a view modally in a `NavigationStack`, dismissing it, and then quickly using the `EdgePanGesture` system to return to the previous view can cause the application to become unresponsive.

### Steps to Reproduce

1. In `CountriesView`, select a country.
2. Tap the `Flag of xxx` button to display the flag.
3. Dismiss the flag view.
4. Quickly return to the list of countries using an system `EdgePanGesture`.
5. The application becomes unresponsive!

### Expected Result

The application should not become unresponsive when `CountryView` is dismissed and the `EdgePanGesture` is used to return to the previous view.

### Actual Result

The application becomes unresponsive when `CountryView` is dismissed and the `EdgePanGesture` is used to return to the previous view.

## Configuration

- OS Version: iOS 16.3.1
- Device: iPhone 13 Pro
- Xcode Version: 14.2.0
- [Code Reproducing the Bug](https://github.com/waliid/issues/tree/main/NavigatonDemo)
- Video showing how to reproduce: [Link 1](https://github.com/waliid/issues/raw/main/NavigatonDemo/video_explained.mp4) - [Link 2](https://drive.google.com/file/d/1Z3nbPww6sX9ZJN5Wve8Wx-o0rGbPZFCi/view?usp=sharing)

## Remarks

I also noticed that this bug does not occur when using the navigation bar back button to dismiss `CountryView`. The problem also does not occur if the

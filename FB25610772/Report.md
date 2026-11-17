# WebKit `WebView` insets its content by the safe area twice when its proposed width is fractional


## Description of the problem

When the WebView from WebKit borders a safe area edge and SwiftUI proposes a width that is not a whole number of points, the web content is inset by the safe area twice. The view no longer extends into the safe area, but it still insets its content by the full safe area inset.

Fractional widths are common in split layouts. We hit this in a side by side layout next to the vertical bar of the unfolded iPhone Duo, where the web content ended 84 pt before the bar.

### Remarks

- Workaround: propose `width.rounded(.down)` to the WebView and place it at the trailing edge, e.g. with a custom `Layout`.

## Steps to reproduce

1. Run the attached sample project on an iPhone simulator.
2. The orange column is 120.5 pt wide, so the WebView gets a fractional width. The purple bar is an 84 pt trailing safe area added with `safeAreaInset(edge: .trailing)`.
3. Look at the red line. It marks the trailing edge of the web content.
4. Select 120 in the column width picker and compare. Only fractional widths trigger the issue, whole widths work as expected.

## Expected results

The red line touches the purple bar in both cases. The WebView extends into the safe area and insets its content by 84 pt once.

## Actual results

With the 120.5 pt column, the red line ends 84 pt before the purple bar (`fractional-width.png`). With the 120 pt column, it touches the bar (`whole-width.png`).

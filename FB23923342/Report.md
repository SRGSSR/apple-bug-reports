# SwiftUI `List` incorrectly reuses stale `Equatable` objects when redrawing

## Description of the problem

SwiftUI `List` needs a `Hashable` identifier associated with each of its items to keep track of updates or store selection, either implicitly or by having items conform to the `Identifiable` protocol. It does not publicly require other formal requirements for its items, e.g. items being value or reference types, or being `Equatable` or `Hashable`.

Nevertheless `List` internally seems to adjust its behavior depending on properties of items it displays, presumably for performance reasons. Most notably, when items in a list are **`Equatable` reference types**, we can observe that `List` implements some kind of item cache, with items not immediately released after they have been removed from a `List`. The cache might be cleared, e.g. in the event of a memory warning, but in general items can remain cached for a while.

The current `List` item cache implementation suffers from an issue that makes `Equatable` objects incorrectly resurface after they have been removed from the list, though. As a result a `List` might sometimes display stale data from the cache, rather than fresh data.

### Remarks

- This issue is not new. We could reproduce it on iOS 16, 17, 18, 26 and 27 devices. We did not test the behavior on earlier versions, though it would be interesting to know if it exists since day 1.
- We already reported a similar caching issue with `List` selection and reference types, see [FB17273780](https://github.com/SRGSSR/apple-bug-reports/blob/main/FB17273780/Report.md). Both are likely related somehow.
- No issue arises with reference types not conforming to `Equatable`.
- No issue arises with `Equatable` reference types in a `ScrollView/VStack/ForEach` nesting, which points at an issue specific to `List`.

### Test setup

Not really relevant (all major iOS versions affected), but here it is anyway:

- Xcode 26.5 and Xcode 27.0 beta 4.
- All kinds of iOS versions, from 16.7.16 up to iOS 26.5.2 and iOS 27.0 beta 4.

## How to reproduce the problem

A sample project is attached to this issue. This project implements a fake downloader:

- `Downloader` makes it possible to add, list and remove downloads.
- `Download` delivers progress updates at random intervals until completion.

To reproduce the issue:

1. Run the sample app with the iOS simulator or a real device. You should likely use iOS 26 as OS version, though all recent OS versions are affected. Filter the Xcode console logs using the string `-->` to observe download deallocations.
2. Tap on the "Add 1" button. This creates and adds a **new** `Download` to the list, with initial progress 0. Wait until the progress bar starts to fill up.
3. Now tap on the "Remove 1" button. This removes the download from the list. Observe that the download is not deallocated.
4. Tap on the "Add 1" button again. This creates and adds a **new** `Download` to the list (identical to the previous one according to `==`), with initial progress 0, but you can observe that the `List` UI incorrectly displays the previous "1" instance.

Now repeat the same scenario, but triggering a simulated memory warning after download removal, as follows:

1. Tap on the "Add 2" button. This creates and adds a **new** `Download` to the list, with initial progress 0. Wait until the progress bar starts to fill up.
2. Now tap on the "Remove 2" button. This removes the download from the list. Observe that the download is not deallocated.
3. Simulate a memory warning, e.g. with the dedicated simulator menu item if you are using the simulator. Observe that deallocation now occurs.
4. Tap on the "Add 2" button again. This creates and adds a **new** `Download` to the list, with initial progress 0. This download correctly starts at 0, probably since no stale equivalent download could be retrieved from the cache.

This scenario can be seen in the attached `List + Equatable` video. 

### Remarks

- In this implementation both `Downloader` and `Download` are `ObservableObject`s. `Observable` objects would be affected in the same way, though.
- If you remove `Equatable` conformance the behavior described above is correct. See attached `List + not Equatable` video.
- If you replace the `List` with a combination of `ScrollView/VStack/ForEach` the behavior described above is correct, even with `Equatable` conformance. See attached `ScrollView/VStack/ForEach + Equatable` video.

## Expected results

`List` always presents up-to-date data.

## Actual results

`List` resurfaces old `Equatable` object instances from an internal cache after they have been removed. These are used instead of fresh identical instances for display. This leads to `List` potentially displaying outdated data, especially when displayed objects have dynamic state (e.g. downloads).

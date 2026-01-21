# SwiftUI List memory behavior is unpredictable or leaking when its underlying data type is a reference type

Description of the problem:
---------------------------

SwiftUI `List` makes it possible to edit the data associated with a list and to promote one (or several of) its items as selection. No assumption is made on the kind of data that is associated with a `List`, except that it should have some way of identifying items.

When using a reference type as underlying List data type, and if the list implements selection and item removal, we can observe the following behaviors:

- When removing an item from the list, and provided the object is not retained elsewhere, the object is not deinitialized immediately. It might during a later list mutation or if a memory warning is triggered, but if no list change is made the object will just stay alive.
- The last selected item is lost forever and will never be deinitialized, e.g. after clearing the list.

The issue is not specific to iOS 18. You can reproduce it as well on earlier versions. The version of Xcode is also not relevant here (I am using 16.3).


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. This example contains a simple list of persons, where `Person` is a implemented as a class (in general you would model such a type with a struct, but sometimes having a class cannot be avoided). The list can be edited and a person can optionally be selected. The `Person.deinit` method also has been implemented to log when a person is deinitialized.

With a device or the simulator (or even with Xcode previews) proceed as follows:

A) First use case:
    1. Launch the app.
    2. Swipe one person to remove them. Avoid making a selection in the process. You can observe that no deinit is logged to the console.
    3. Repeat removal without selection. Observe that no deinits are logged until all persons have been removed.

B) Second use case:
    1. Launch the app.
    2. Swipe each person to remove them, triggering a memory warning in between swipes. Avoid making a selection in the process. You can observe that deinits are logged to the console, but never for the most recent removed person. Once all persons have been removed all associated deinits have been logged to the console.

C) Third use case:
    1. Launch the app.
    2. Swipe one person to remove them. Avoid making a selection in the process. No deinit is logged to the console. 
    3. Tap on the trash button. All expected deinits are immediately logged to the console.

D) Fourth use case:
    1. Launch the app.
    2. Swipe one person to remove them. Avoid making a selection in the process. No deinit is logged to the console. 
    3. Tap on the trash button. All expected deinits are logged to the console.

E) Fifth use case:
    1. Launch the app.
    2. Select one person.
    3. Remove any person (possibly the one you selected). No deinit is logged to the console.
    4. Tap on the trash button. You can observe that the last selected person is never deinitialized.
    5. Repeat starting from 1, with different selection scenarios. Observe that in all cases the last selected item is never properly deinitialized.

After running these use cases you now hopefully have a better idea of the issues I am reporting. I also attached a video where you can see an example where deferred deinitialization can be observed, as well as incorrectly missing deallocation for the last item (the video was captured using Xcode previews for convenience).


Expected results:
-----------------

Using `List` with a reference type as underlying data type leads to predictable deallocation behavior:

- If an item is removed and not retained elsewhere, its deinit method is triggered just after removal.
- If an item has been selected and is then removed, its deinit method is triggered.


Actual results:
---------------

Using `List` with a reference type as underlying data type leads to strange deallocation behavior:

- If an item is removed and not retained elsewhere, its deinit method is not triggered immediately, but only after removal of other items and or when a memory warning is triggered.
- The last selected item, if any, is never properly deinitialized.

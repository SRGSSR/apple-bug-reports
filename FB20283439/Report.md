# iOS 26.0 regression: Slider onEditingChanged closure is unreliable

Description of the problem:
---------------------------

Starting with iOS 26, the `Slider` `onEditingChanged` closure is called too many times and with incorrect values. As a result apps cannot reliably determine when interaction starts or ends.

Remark: The iOS 26.0 (23A341) release is sadly not available from the build selector. I therefore picked "Seed 8" instead.


How to reproduce the problem:
-----------------------------

A sample project is attached to this issue. This simple app displays a `Slider`, bound to a local state and with an `onEditingChanged` closure that prints the associated received Boolean value to the console.

Repeat the following scenario on two physical devices, one running iOS 18, the other one running iOS 26:

1. Run the application on a device.
2. Grab the slider knob, move it and release it, all while observing the console. Do it a few times in a row.

You should observe that:

- On iOS 18, and for each single knob interaction, `onEditingChanged` is called twice, with `true` when editing begins, and with `false` when it ends.
- On iOS 26, `onEditingChanged` can be called more than twice, with final flag set to `true`.


Expected results:
-----------------

When moving the knob of a `Slider`, `onEditingChanged` is always called once with `true` when editing begins and once with `false` when editing ends.


Actual results:
---------------

When moving the knob of a `Slider`, `onEditingChanged` behavior is unreliable. The closure might be called more than twice and the Boolean value provided to the closure is usually incorrect as a result.
# PhaseAnimator freeze the UI (FB12753233)

## Description

Using PhaseAnimator API causes a UI freeze.

## Steps to Reproduce

1. Open the demo app.
2. Press "Sheet" button.
3. Close the sheet.
4. Try to press again of the "Sheet" button.

## Expected Result

The sheet should be open back.

## Actual Result

The App is frozen.

## Configuration

- OS Version: iOS 17 Beta 5
- Device: IPad Pro
- Xcode Version: Xcode 15 Beta 5
- [Code Reproducing the Bug](https://github.com/waliid/issues/tree/main/PhaseAnimatorDemo)

# Remarks

This behavior cannot be reproduced on iOS 17 Beta 4.

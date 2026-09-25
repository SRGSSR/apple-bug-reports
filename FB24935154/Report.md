# Xcode 27 regression: "Select Next/Previous Occurrence" matches against previous search pattern

## Description of the problem

Until Xcode 26, "Select Next Occurrence" and "Select Previous Occurrence" were behaving in a way that makes sense, i.e.:

1. Select the word "Hello", then use "Select Next Occurrence" several times. This adds each occurrence of "Hello" to the selection in succession.
2. Select another word "World", then use "Select Next Occurrence" several times. This adds each occurrence of "World" to the selection in succession.

This behavior makes it quick and easy to perform multiple changes at the same time using multi-cursor support.

Starting with Xcode 27, though, the behavior was slightly altered because the context between steps 1 and 2 is not cleared anymore. This means:

1. Select the word "Hello", then use "Select Next Occurrence" several times. This adds each occurrence of "Hello" to the selection in succession.
2. Select another word "World", then use "Select Next Occurrence" several times. This adds "World" to the selection, followed by each occurrence of "Hello" (the previous search term) in succession.

The only way to return to the pre-Xcode 27 behavior is to clear the selection between searches, which is annoying.

### Remark

Still an issue with Xcode 27.1 and 27.2 beta.

## How to reproduce the problem

Please check the attached videos. I used a tool that displays keyboard presses ([KeyScreen](https://keyscreen.app)) so that you can follow what happens with each key press.

### Xcode 26

Video: _xcode26_

1. Right after Xcode 26 is started (no previous search was active), the word _subtitle_ is selected.
2. With each Option+Command+E key press ("Select Next Occurrence"), each occurrence of _subtitle_ is added to the selection. Selection contains only occurrences of the _subtitle_ word.
3. The word _imageUrl_ is selected. 
4. With each Option+Command+E key press ("Select Next Occurrence"), each occurrence of _imageUrl_ is added to the selection. Selection contains only occurrences of the _imageUrl_ word.

This is sound and expected behavior.

### Xcode 27

Video: _xcode27_

1. Right after Xcode 27 is started (no previous search was active), the word _subtitle_ is selected.
2. With each Option+Command+E key press ("Select Next Occurrence"), each occurrence of _subtitle_ is added to the selection. Selection contains only occurrences of the _subtitle_ word.
3. The word _imageUrl_ is selected. 
4. With each Option+Command+E key press ("Select Next Occurrence"), each occurrence of _subtitle_ is added to the selection. Selection now contains a mixture of a single occurrence of _imageUrl_, followed by occurrences of the _subtitle_ word.

This behavior does not feel right. Selection mixes current and old search criteria, with more matches for the old criterium than the new selected term.

#### Workaround

What happens since Xcode 27 is that the search criterium is not correctly updated when already filled and toggling "Select Next Occurrence". This is why the selection incorrectly resurfaces the previous search term.

To observe it, check the _xcode27-search-clear_ video, in which the criterium is manually reset before the second search:

1. Right after Xcode 27 is started (no previous search was active), the word _subtitle_ is selected.
2. With each Option+Command+E key press ("Select Next Occurrence"), each occurrence of _subtitle_ is added to the selection. Selection contains only occurrences of the _subtitle_ word.
3. The search field is revealed with Command+F and the search criterium is cleared.
4. The word _imageUrl_ is selected. 
5. With each Option+Command+E key press ("Select Next Occurrence"), each occurrence of _imageUrl_ is added to the selection. Selection contains only occurrences of the _imageUrl_ word.

Having to manually clear the search field between searches is unncessarily tedious. As a result the user experience is poor.

## Expected results

"Select Next/Previous Occurence" works in Xcode 27 as it was working in Xcode 26 and earlier, i.e. each search term is replaced when changing the current selection and toggling "Select Next/Previous Occurence".

## Actual results

Starting with Xcode 27 the "Select Next/Previous Occurence" context is not cleared between searches, which makes old matches resurface after a new term was selected. The resulting user experience is poor. 
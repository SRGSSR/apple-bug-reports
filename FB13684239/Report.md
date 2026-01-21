# MPNowPlayingSession: Control Center playback button status is incorrect in presence of several player instances

Description of the problem:
---------------------------

`MPNowPlayingSession` can be used to associate now playing metadata as well as remote commands with the current playback session. Starting with iOS 16 new APIs are even provided to associate a session with one or several player instances or to make a current session the active one, so that its associated metadata and controls are displayed in the Control Center. See https://developer.apple.com/videos/play/wwdc2022/110338/ for more information.

Applications might want to implement custom user experiences in which several players are playing at the same time. One such experience could be a sports-dedicated app where a main player instance displays the current stream the user is most interested in (e.g. some tennis match during a Grand Slam event), with peripheral smaller players displaying other streams which the user wants to follow simultaneously (e.g. other tennis matches occurring at the same time during the same Grand Slam event). At any time the user might want to switch to a peripheral stream, making it the main one.

In such user experiences we want to be able to integrate the main player instance with the Control Center, changing it when the user picks another peripheral stream to make it the main one. Since an `MPNowPlayingSession` can be associated with each player this should be as easy as calling `becomeActiveIfPossible()` on the session associated with the new main player instance, so that its metadata gets displayed in the Control Center, with controls reflecting the current player playback state.

This works fine for metadata (title, artwork) as well as time information (e.g. current playback position), but the playback button is not correctly updated to reflect the associated player rate when changing the active session in multi-instance scenarios. As a result the Control Center playback button does not work as expected.

Remark: This issue is reported for iOS 17 but exists since a long time. It is also not related to the new iOS 16 `MPNowPlayingSession` APIs. I could namely reproduce the issue with manual now playing session / remote command center singleton management on iOS 15, for example.


How to reproduce the problem:
-----------------------------

I attached a sample project to this issue. This project implements a multi-stream playback experience with a top player and a bottom player, equal in size, both playing at the same time. When the app starts the top player is integrated with the Control Center (active session) and, at any time, Control Center integration can be moved to the other instance with a button tap.

To reproduce the issue:

Scenario 1
................

1. Build and run the app on a physical device. Bip Bop is played at the top and a Morning Show trailer simultaneously at the bottom.
2. Observe that there is a button with an arrow between the players, pointing at the player for which the associated now playing session is currently active.
3. With the arrow pointing up, open the Control Center. You can observe that the Control Center correctly displays "Bip Bop" with a pause button (since the player is actually playing).
4. Close the Control Center and tap on the pause button located on top of the Bip Bop video. Open the Control Center again to observe that the playback button is not updated correctly (a pause button is displayed instead of play button).
5. Close the Control Center and tap on the pause button located on top of the Morning Show video. Open the Control Center again to observe that the playback button is now displaying a play button (all players are now paused, which could explain this behavior).

You can see this scenario in the corresponding attached video.

Scenario 2
................

1. Build and run the app on a physical device. Bip Bop is played at the top and a Morning Show trailer simultaneously at the bottom.
2. Observe that there is a button with an arrow between the players, pointing at the player for which the associated now playing session is currently active.
3. With the arrow pointing up, open the Control Center. You can observe that the Control Center correctly displays "Bip Bop" with a pause button (since the player is actually playing).
4. Close the Control Center and tap on the button located in between the players. Open the Control Center again and observe that the metadata has been correctly updated to "The Morning Show", but that the playback button is an incorrect state. After tapping a few times on this button you can get a consistent state again, matching the one of the bottom player.

You can see this scenario in the corresponding attached video.


Expected results:
-----------------

When calling `becomeActiveIfPossible()` on an `MPNowPlayingSession` associated with a player, the Control Center playback button state reflects the state of the associated player.


Actual results:
---------------

When calling `becomeActiveIfPossible()` on an `MPNowPlayingSession` associated with a player, the Control Center playback button state reflects the state not only of the related player, but of other player simultaneously present at the same time.


Fix idea:
--------

Maybe `MPNowPlayingInfoPropertyPlaybackRate` could be used to drive the Control Center playback button state (if not present a value based no the rate of the players associated with the session could be likely guessed).
# Improve DocC support for projects supporting several platforms

Context
--------

An API might be unavailable for some platform, whether because it has been marked as unavailable or because the corresponding code is not compiled for the platform (e.g. using preprocessor conditions).

DocC currently has a few limitations and issues with projects supporting multiple platforms:

1. When writing an article, tutorial or documentation in general, some paragraph might reference symbols which are not available on the platform for which the documentation is built. A warning is emitted for the unavailable symbol but the generated documentation is not relevant and will contain non-working links to types not available for the platform. 
2. When arranging APIs into topics (https://developer.apple.com/documentation/xcode/adding-structure-to-your-documentation-pages#Arrange-top-level-symbols-using-topic-groups) symbols are referenced in bullet lists. In such cases warnings are emitted by DocC and no entry is added to the generated documentation (as should be).


Possible improvements
---------------------

DocC should provide a way to mark part of a documentation as only relevant for some platform(s). Such sections would be ignored when generating documentation for other platforms.

For symbols appearing in topics bullet lists the same approach could be used or, as today, unknown symbols could be simply ignored in the output but without generating irrelevant warnings.


Example
--------

I attached a sample Swift package to this suggestion, providing a Swift package compatible with iOS and tvOS but offering some APIs only for iOS:

1. Open the package manifest with Xcode.
2. Build the documentation for an iOS target (Xcode menu > Product > Build Documentation). Everything works fine.
3. Build the documentation for a tvOS target. Two warnings are displayed.


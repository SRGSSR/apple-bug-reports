# Swift Package Manager: Module aliases cannot be used to fix product name conflicts between two dependencies of a Swift package manifest

Description of the problem:
---------------------------

It might happen that a Swift package declares two dependencies "dependency1" and "dependency2" which deliver libraries bearing the same name "ConflictingName". In such cases package resolution fails with an error:

> multiple targets named 'ConflictingName' in: 'dependency1', 'dependency2'; consider using the `moduleAliases` parameter in manifest to provide unique names

When attempting to use `moduleAliases`, though, the error disappears but another one is raised when building the package:

> Build service could not create build operation: unable to load transferred PIF: PIFLoader: GUID 'PRODUCTREF-PACKAGE-PRODUCT:Core-59974D35D-dynamic' has already been registered

This was reproduced with Xcode 15.1 and 15.2 beta.


How to reproduce the problem:
-----------------------------

I attached a sample project to this issue. This project is made of 3 local Swift packages to mimic a real-life scenario:

- "Alamofire" which represents a networking package. This package provides frameworks called Networking and Core (with Networking depending on Core in this example).
- "Pillarbox" which represents a media playback package. This package provides frameworks called Player and Core (with Player depending on Core in this example).
- "StandardPlayback" which represents a package delivering some standard media playback experience. This package depends on the other two (local) packages for network data retrieval and playback capabilities. A library target is declared which depends on both Core products provided by the two packages it depends on.

To reproduce the issue:

1. Open the StandardPlayback Package.swift file with Xcode 15.1.
2. Build the project. The "Build service" error reported above is displayed and the project fails to compile.


Expected results:
-----------------

`moduleAliases` can be successfully used in a Swift package manifest to avoid name conflicts between libraries exposed by two transitive dependencies of the package.


Actual results:
---------------

`moduleAliases` cannot be used in a Swift package manifest to avoid name conflicts between libraries exposed by two transitive dependencies of the package. The project simply fails to build.

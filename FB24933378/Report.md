# `Codable` types entirely made of nullable properties are not (de-)serialized correctly

## Description of the problem

SwiftData supports `Codable` type serialization. Consider a `Codable` type which is entirely made of optional properties:

```swift
struct Address: Codable {
    let street: String?
    let city: String?
}
```

A `@Model` object might want to store an instance of this type as a non-nullable property:

```swift
@Model
final class Person {
    @Attribute(.unique)
    var id: UUID = UUID()

    var name: String
    var address: Address

    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
}
```

We can insert a person with all address properties set to `nil`:

```swift
modelContext.insert(Person(name: Self.randomName(), address: Address(street: nil, city: nil)))
```

When reading the inserted `Person` from the store, though, the `Address` reconstructed from stored information is `nil`. Since the `Address` property is ultimately declared as being non-nullable for a `Person`, a `fatalError` is raised (see attached _fatal_error_ screenshot).

### Remarks

- The issue has been reported for iOS but affects other platforms as well.
- The issue is not tied to a specific OS version and can be reproduced with OS 17, 18, 26 and 27 releases. 
- Visual data representations attached to this issue have been produced using the [Core Data Lab](https://apps.apple.com/us/app/core-data-lab/id1460684638?mt=12) app.

## How to reproduce the problem

A sample project using the above data model is attached to this issue. To reproduce the problem:

1. Run the sample app with a device or the simulator, for example using Xcode 27 and OS 27 releases. The application _Library_ path is logged to the console if further store inspection is needed.
2. Tap on the _Add (w/ address)_ button to add a person with a filled address.
3. Send the app to the background, then resume it. Everything works fine. Check the attached _with_address_ screenshot for a glimpse of how the corresponding stored data looks like.
4. Tap on the _Add (w/o address)_ button to add a person with an empty address (all fields `nil`).
5. Send the app to the background, then resume it. The app crashes (see _fatal_error_ screenshot). Check the attached _without_address_ screenshot for a glimpse of how the corresponding stored data looks like.

## Workaround

A workaround is to insert an optional reserved field in the `Codable` type:

```swift
struct Address: Codable {
    private var _reserved: String? = ""

    let street: String?
    let city: String?
}
```

The field is private to prevent external changes, assigned a value and optional so that usual decoding is still possible without knowing the private field existence (e.g. parsing a JSON).

## Expected results

SwiftData correctly (de-)serializes `Codable` instances entirely made of nullable properties.

## Actual results

SwiftData incorrectly (de-)serializes `Codable` instances entirely made of nullable properties. When reconstructed from storage they are returned as `nil` rather as empty instances, breaking potential nullability constraints declared by `@Model` objects referencing them. This leads to crashes at runtime.
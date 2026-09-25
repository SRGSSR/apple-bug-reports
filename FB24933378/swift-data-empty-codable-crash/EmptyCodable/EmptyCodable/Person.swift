import Foundation
import SwiftData

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

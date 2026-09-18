import Foundation

enum Flavor: String, CaseIterable, Identifiable {
    case hazelnut, caramel, vanilla, chocolate, pistachio

    var id: String { rawValue }
    var name: String { rawValue.capitalized }
}

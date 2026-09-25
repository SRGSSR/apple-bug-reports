import SwiftUI

struct PersonCell: View {
    let person: Person

    var body: some View {
        VStack(alignment: .leading) {
            Text(person.name)
            if let city = person.address.city {
                Text(city)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

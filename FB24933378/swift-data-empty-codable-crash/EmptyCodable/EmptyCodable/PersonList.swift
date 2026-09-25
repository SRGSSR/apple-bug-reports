import SwiftData
import SwiftUI

struct PersonList: View {
    @Query(sort: \Person.name) var persons: [Person]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            if !persons.isEmpty {
                list()
            }
            else {
                emptyView()
            }
        }
        .animation(.default, value: persons)
        .navigationTitle("Persons")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: addPersonWithAddress) {
                    Text("Add (w/ address)")
                }
            }
            ToolbarItem {
                Button(action: addPersonWithoutAddress) {
                    Text("Add (w/o address)")
                }
            }
        }
    }

    private func list() -> some View {
        List {
            ForEach(persons) { person in
                PersonCell(person: person)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    modelContext.delete(persons[index])
                }
            }
        }
    }

    private func emptyView() -> some View {
        ContentUnavailableView("Nobody", image: "person")
    }

    private func addPersonWithAddress() {
        modelContext.insert(Person(name: Self.randomName(), address: Self.randomAddress()))
    }

    private func addPersonWithoutAddress() {
        modelContext.insert(Person(name: Self.randomName(), address: Address(street: nil, city: nil)))
    }
}

extension PersonList {
    private static func randomName() -> String {
        [
            "Alice",
            "Bob",
            "Charlie",
            "Diana",
            "Ethan",
            "Fiona",
            "George",
            "Hannah",
            "Ian",
            "Julia",
            "Kevin",
            "Laura",
            "Michael",
            "Nina",
            "Oliver",
            "Paula",
            "Quentin",
            "Rachel",
            "Samuel",
            "Victoria"
        ].randomElement()!
    }

    private static func randomStreet() -> String {
        [
            "Oak Street",
            "Maple Avenue",
            "Cedar Lane",
            "Pine Road",
            "Willow Street",
            "Elm Avenue",
            "Birch Lane",
            "Rosewood Road",
            "Chestnut Street",
            "Meadow Drive",
            "Linden Avenue",
            "Parkside Lane",
            "Hawthorn Road",
            "Riverside Street",
            "Garden Avenue",
            "Hillcrest Road",
            "Brook Lane",
            "Sunset Drive",
            "Woodland Street",
            "Orchard Avenue"
        ].randomElement()!
    }

    private static func randomCity() -> String {
        [
            "Zurich",
            "Lisbon",
            "Oslo",
            "Kyoto",
            "Vancouver",
            "Prague",
            "Marrakesh",
            "Helsinki",
            "Brisbane",
            "Edinburgh",
            "Reykjavik",
            "Valencia",
            "Montreal",
            "Florence",
            "Seoul",
            "Porto",
            "Copenhagen",
            "Auckland",
            "Tallinn",
            "Dubrovnik"
        ].randomElement()!
    }

    private static func randomAddress() -> Address {
        .init(street: randomStreet(), city: randomCity())
    }
}

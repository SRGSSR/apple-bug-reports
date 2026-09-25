import SwiftData
import SwiftUI

@main struct EmptyCodableApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PersonList()
            }
            .onAppear {
                print("--> Store found in \(URL.applicationSupportDirectory)")
            }
        }
        .modelContainer(for: Person.self)
    }
}

//
//  ContentView.swift
//  NavigationDemo
//
//  Created by Walid on 04.03.23.
//

import SwiftUI

enum Country: String {
    case switzerland
    case france
    case usa

    var name: String {
        self.rawValue.prefix(1).capitalized + self.rawValue.dropFirst()
    }

    var flag: String {
        switch self {
        case .switzerland: return "🇨🇭"
        case .france: return "🇫🇷"
        case .usa: return "🇺🇸"
        }
    }
}

struct CountriesView: View {
    let Countries: [Country] = [.switzerland, .france, .usa]

    var body: some View {
        NavigationStack {
            List(Countries, id: \.self) { country in
                NavigationLink(country.name) {
                    CountryView(country: country)
                }
            }
            .navigationTitle("Countries")
        }
    }
}

struct CountryView: View {
    @State private var isPresented: Bool = false
    let country: Country

    var body: some View {
        VStack {
            Button("Flag of \(country.name)") {
                isPresented.toggle()
            }
            .sheet(isPresented: $isPresented) {
                FlagView(country: country)
            }
        }
    }
}

struct FlagView: View {
    let country: Country

    var body: some View {
        ZStack {
            Text(country.flag)
        }
    }
}

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}

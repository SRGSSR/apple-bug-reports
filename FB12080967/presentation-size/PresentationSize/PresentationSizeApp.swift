//
//  PresentationSizeApp.swift
//  PresentationSize
//
//  Created by Walid on 20.03.23.
//

import ShowTime
import SwiftUI

@main
struct PresentationSizeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ShowTime.enabled = .always
                }
        }
    }
}

//
//  PPADApp.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import SwiftUI

@main
struct PPADApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Settings())
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}

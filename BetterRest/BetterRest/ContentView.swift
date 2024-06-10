//
//  ContentView.swift
//  BetterRest
//
//  Created by HTLILI on 10/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmout = 8.0
    @State private var coffeeAmount = 1
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

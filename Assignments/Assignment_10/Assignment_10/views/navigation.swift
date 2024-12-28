//
//  navigation.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/19/24.
//

import SwiftUI

struct navigation: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Go to Step 1") { path.append("Step 1") }
                Button("Go to Step 2") { path.append("Step 2") }
            }
            .navigationDestination(for: String.self) { step in
                if step == "Step 1" {
                    Customers()
                } else if step == "Step 2" {
                    Policies()
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    navigation()
}

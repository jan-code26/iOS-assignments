//
//  Policies.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/18/24.
//

import SwiftUI

struct Policies: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Policies_data.policy_type, ascending: true)
        ],animation: .default)
    private var items: FetchedResults<Policies_data>
    
    @State private var searchText = ""
    
    
    var body: some View {
    NavigationView {
        VStack {
            TextField("Search by policy type", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List(filteredItems) { item in
                NavigationLink(destination: PolicyDetailView(policy: item)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.policy_type ?? "Unknown Policy")
                            Text("Premium Amount: \(item.premium_amount)")
                        }
                        Spacer()
                        Image(systemName: iconName(for: item.policy_type))
                            .foregroundColor(.blue)
                    }
                }
            }
        }.navigationTitle("Policies")
        }
    }
    
    private var filteredItems: [Policies_data] {
        if searchText.isEmpty {
            return Array(items)
        } else {
            return items.filter { $0.policy_type?.localizedCaseInsensitiveContains(searchText) == true }
        }
    }
    
    private func iconName(for policyType: String?) -> String {
        switch policyType {
        case "Home":
            return "house.fill"
        case "Auto":
            return "car.fill"
        case "Health":
            return "heart.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
}


#Preview {
    Policies()
}

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
            NSSortDescriptor(
                keyPath: \Policies_data.policy_type, ascending: true)
        ], animation: .default)
    private var items: FetchedResults<Policies_data>

    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by policy type", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isSearchFieldFocused)
                List {
                    ForEach(filteredItems, id: \.self) { item in
                        NavigationLink(
                            destination: PolicyDetailView(policy: item)
                        ) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.policy_type ?? "Unknown Policy")
                                    Text(
                                        "Premium Amount: \(item.premium_amount)"
                                    )
                                }
                                Spacer()
                                Image(
                                    systemName: iconName(for: item.policy_type)
                                )
                                .foregroundColor(.blue)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationBarItems(
                    leading: Text("Policies"),
                    trailing: NavigationLink(destination: PolicyAddView()) {
                        Image(systemName: "plus.circle.dashed")
                    })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
    }

    private var filteredItems: [Policies_data] {
        if searchText.isEmpty {
            return Array(items)
        } else {
            return items.filter {
                $0.policy_type?.localizedCaseInsensitiveContains(searchText)
                == true
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            let currentDate = Date()
            if item.end_date! > currentDate {
                alertMessage = "Insurance is active and cannot be deleted"
                showAlert = true
                return
            }
            viewContext.delete(item)
        }
        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error deleting item: \(error)")
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

//
//  Customers.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/18/24.
//

import SwiftUI

struct Customers: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Customers_data.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Customers_data.name, ascending: true)
        ],
        animation: .default)
    private var items: FetchedResults<Customers_data>
    
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(){
                TextField("Search by name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                List(filteredItems) { item in
                    NavigationLink(destination: CustomerDetailView(customer: item)) {
                        
                        HStack {
                            AsyncImage(url: URL(string: item.avatar!)) { phase in
                                switch phase {
                                case .failure: Image(systemName: "photo").font(.largeTitle)
                                case .success(let image):
                                    image.resizable()
                                default: ProgressView()
                                    
                                }
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown Name")
                                    .font(.headline)
                                Text("Age: \(item.age)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }.navigationTitle("Customers")
        }

    }
    
    private var filteredItems: [Customers_data] {
        if searchText.isEmpty {
            return Array(items)
        } else {
            return items.filter { $0.name?.localizedCaseInsensitiveContains(searchText) == true }
        }
    }
}

#Preview {
    Customers()
}

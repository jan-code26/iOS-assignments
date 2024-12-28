//
//  Customers.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/18/24.
//

import CoreData
import SwiftUI

struct Customers: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Customers_data.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Customers_data.id, ascending: true)
        ],
        animation: .default)
    private var items: FetchedResults<Customers_data>

    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            
            VStack {
                TextField("Search by name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isSearchFieldFocused)
                List {
                    ForEach(filteredItems, id: \.self) { item in
                        NavigationLink(
                            destination: CustomerDetailView(customer: item)
                        ) {
                            if item.avatar_image != nil {
                                HStack {
                                    Image(
                                        uiImage: UIImage(
                                            data: item.avatar_image!)!
                                    )
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12))

                                }
                            } else if item.avatar != nil {
                                HStack {
                                    AsyncImage(url: URL(string: item.avatar!)) {
                                        phase in
                                        switch phase {
                                        case .failure:
                                            Image(systemName: "photo").font(
                                                .largeTitle)
                                        case .success(let image):
                                            image.resizable()
                                        default: ProgressView()

                                        }
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown Name")
                                    .font(.headline)
                                Text("Age: \(item.age)")
                                    .font(.subheadline)
                                Text("Id: \(item.id)")
                                    .font(.subheadline)
                            }
                        }

                    }.onDelete(perform: deleteItems)
                }
            }.navigationBarItems(
                leading: Text("Customers"),
                trailing: NavigationLink(destination: CustomerAddView()) {
                    Image(systemName: "plus.circle.dashed")
                })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .scrollDismissesKeyboard(.immediately)
        }

    }

    private var filteredItems: [Customers_data] {
        if searchText.isEmpty {
            return Array(items)
        } else {
            return items.filter {
                $0.name?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]

            let fetchRequest: NSFetchRequest<Policies_data> =
                Policies_data.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "customer_id == %d", item.id)
            let result = try? viewContext.fetch(fetchRequest)
            if result != nil {
                if result!.count > 0 {
                    alertMessage = "Customer has policies, please delete policies first"
                    showAlert = true
                    return
                }
            }

            viewContext.delete(item)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
#Preview {
    Customers()
}

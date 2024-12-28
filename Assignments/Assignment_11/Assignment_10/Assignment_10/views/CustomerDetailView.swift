//
//  CustomerDetailView.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/19/24.
//

import CoreData
import SwiftUI

struct ErrorWrapper: Identifiable {
    var id = UUID()
    var message: String
}

struct CustomerDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var age: Int
    @State private var email: String
    @State private var avatar: String
    @State private var avatar_image: Data
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var errorMessage: ErrorWrapper? = nil

    var customer: Customers_data

    init(customer: Customers_data) {
        self.customer = customer
        _name = State(initialValue: customer.name ?? "")
        _age = State(initialValue: Int(customer.age))
        _email = State(initialValue: customer.email ?? "")
        _avatar = State(initialValue: customer.avatar ?? "")
        _avatar_image = State(initialValue: customer.avatar_image ?? Data())
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Name")) {
                        TextField("Name", text: $name)
                    }
                    Section(header: Text("Age")) {
                        TextField(
                            "Age", value: $age, formatter: NumberFormatter()
                        ).keyboardType(.numberPad)
                    }
                    Section(header: Text("Email")) {
                        TextField("Email", text: $email).disabled(true)
                    }
                    Section(header: Text("Avatar")) {
                        if let selectedImage = selectedImage {
                            HStack {
                                Spacer()
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12))
                                Spacer()
                            }
                        } else if !avatar_image.isEmpty {
                            HStack {
                                Spacer()
                                Image(uiImage: UIImage(data: avatar_image)!)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12))
                                Spacer()
                            }
                        } else if !avatar.isEmpty {
                            HStack {
                                Spacer()
                                AsyncImage(url: URL(string: avatar)) { phase in
                                    switch phase {
                                    case .failure:
                                        Image(systemName: "person.fill").font(
                                            .largeTitle)
                                    case .success(let image):
                                        image.resizable()
                                    default:
                                        ProgressView()
                                    }
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                Spacer()
                            }
                        } else {
                            HStack {
                                Spacer()
                                Image(systemName: "person.fill").font(
                                    .largeTitle
                                )
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                Spacer()
                            }
                        }
                    }
                    .onTapGesture {
                        showImagePicker = true
                    }
                }

                Button("Update") {
                    // Update the customer function
                    updateCustomer(customer: customer)
                }.buttonStyle(.bordered)
            }
            .navigationTitle("Customer Details")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
             .alert(item: $errorMessage) { errorWrapper in
                             Alert(title: Text("Error"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK")))
                         }
        }
    }

    func updateCustomer(customer: Customers_data) {
        // Update the customer
        // Validate fields
               guard !name.isEmpty else {
                          errorMessage = ErrorWrapper(message: "Name cannot be empty")
                          return
                      }
                      guard age > 0 else {
                          errorMessage = ErrorWrapper(message: "Age must be greater than zero")
                          return
                      }
        // Save the context
        do {
            customer.name = name
            customer.age = Int64(age)
            customer.email = email
            customer.avatar = avatar
            if let selectedImage = selectedImage {
                customer.avatar_image = selectedImage.jpegData(
                    compressionQuality: 1.0)
            }
            try customer.managedObjectContext?.save()
            //            go back to the previous view
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct CustomerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType)

        //        Intiliaze the Customer_data instance
        let customer = Customers_data(context: context)
        customer.name = "John Doe"
        customer.age = 30
        customer.email = "Doe@mail.com"
        customer.avatar =
            "https://robohash.org/maioresdistinctiosunt.png?size=50x50&set=set1"
        return CustomerDetailView(customer: customer)
    }
}

#Preview {
    CustomerDetailView(customer: Customers_data())
}

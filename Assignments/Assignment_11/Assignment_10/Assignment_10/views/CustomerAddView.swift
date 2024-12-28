//
//  CustomerAddView.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/30/24.
//

import SwiftUI
import CoreData

struct CustomerAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var email: String = ""
    @State private var avatar: String = ""
    @State private var avatar_image: Data = Data()
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var errorMessage: ErrorWrapper? = nil

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
                        TextField("Email", text: $email)
                    }
                    Section(header: Text("Avatar")) {
                        if let selectedImage = selectedImage {
                            HStack {
                                Spacer()
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
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
                Button("Add") {
                    addCustomer()
                }.buttonStyle(.bordered)
            }

        }
        .navigationTitle("Add Customer")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert(item: $errorMessage) { errorWrapper in
            Alert(
                title: Text("Error"), message: Text(errorWrapper.message),
                dismissButton: .default(Text("OK")))
        }
    }

    func addCustomer() {
        // Add the customer
        // Validate fields
        guard !name.isEmpty else {
            errorMessage = ErrorWrapper(message: "Name is required")
            return
        }
        guard age > 0 else {
            errorMessage = ErrorWrapper(message: "Age must be greater than 0")
            return
        }
        guard !email.isEmpty else {
            errorMessage = ErrorWrapper(message: "Email is required")
            return
        }
        guard isValidEmail(email) else {
            errorMessage = ErrorWrapper(message: "Invalid email")
            return
        }
        guard isNewEmail(email) else {
            errorMessage = ErrorWrapper(message: "Email already exists")
            return
        }

        //        if empty image same person.fill image will be added
        if let selectedImage = selectedImage {
            avatar_image = selectedImage.pngData()!
        } else {
            avatar_image = UIImage(systemName: "person.fill")!.jpegData(
                compressionQuality: 1.0)!
        }

        let customer = Customers_data(
            context: PersistenceController.shared.container.viewContext)
        customer.id = getNextCustomerId()
        customer.name = name
        customer.age = Int64(age)
        customer.email = email
        customer.avatar_image = avatar_image

        do {
            try PersistenceController.shared.container.viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }

    private func getNextCustomerId() -> Int64 {
            let fetchRequest: NSFetchRequest<Customers_data> = Customers_data.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Customers_data.id, ascending: false)]
            fetchRequest.fetchLimit = 1

            do {
                let lastCustomer = try PersistenceController.shared.container.viewContext.fetch(fetchRequest).first
                return (lastCustomer?.id ?? 0) + 1
            } catch {
                fatalError("Failed to fetch last customer ID: \(error)")
            }
        }

        private func isNewEmail(_ email: String) -> Bool {
            let fetchRequest: NSFetchRequest<Customers_data> = Customers_data.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            do {
                let result = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
                return result.isEmpty
            } catch {
                fatalError("Failed to fetch customer: \(error)")
            }
        }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

#Preview {
    CustomerAddView()
}

//
//  PolicyAddView.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/30/24.
//

import SwiftUI
import CoreData

struct PolicyAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var policyType: String = ""
    @State private var premiumAmount: Double = 0.0
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var errorMessage: ErrorWrapper? = nil
    @State private var customerID: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Policy Type")) {
                        TextField("Policy Type", text: $policyType)
                    }
                    Section(header: Text("Premium Amount")) {
                        TextField(
                            "Premium Amount", value: $premiumAmount,
                            formatter: NumberFormatter()
                        ).keyboardType(.decimalPad)
                    }
                    Section {
                        DatePicker(
                            "Start Date", selection: $startDate,
                            displayedComponents: .date)
                    }
                    Section {
                        DatePicker(
                            "End Date", selection: $endDate,
                            displayedComponents: .date)
                    }
                    Section(header: Text("Customer ID")) {
                        TextField(
                            "Customer ID", value: $customerID,
                            formatter: NumberFormatter()
                        ).keyboardType(.numberPad)
                    }
                }
                Button("Add") {
                    // Add the policy function
                    addPolicy()
                }.buttonStyle(.bordered)
            }
            .navigationTitle("Add Policy")
             .alert(item: $errorMessage) { errorWrapper in
                                        Alert(title: Text("Error"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK")))
                                    }
        }
    }

    func customerExists(id: Int, context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Customers_data> = Customers_data.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let customers = try context.fetch(fetchRequest)
            return customers.count > 0
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func addPolicy() {
    // Validate fields
        if policyType.isEmpty {
            errorMessage = ErrorWrapper(message: "Policy Type is required")
            return
        }
        if premiumAmount <= 0 {
            errorMessage = ErrorWrapper(message: "Premium Amount must be greater than 0")
            return
        }
        if startDate > endDate {
            errorMessage = ErrorWrapper(message: "Start Date must be before End Date")
            return
        }
        if customerID <= 0 {
            errorMessage = ErrorWrapper(message: "Customer ID must be greater than 0")
            return
        }
        if !customerExists(id: customerID, context: PersistenceController.shared.container.viewContext) {
            errorMessage = ErrorWrapper(message: "Customer with ID \(customerID) does not exist")
            return
        }



        let policy = Policies_data(
            context: PersistenceController.shared.container.viewContext)
        policy.policy_type = policyType
        policy.premium_amount = premiumAmount
        policy.start_date = startDate
        policy.end_date = endDate
        policy.customer_id = Int64(customerID)

        do {
            try PersistenceController.shared.container.viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    PolicyAddView()
}

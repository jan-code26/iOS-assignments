//
//  PolicyDetailView.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/19/24.
//

import CoreData
import SwiftUI


struct PolicyDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var policyType: String
    @State private var premiumAmount: Double
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var errorMessage: ErrorWrapper? = nil

    var policy: Policies_data

    init(policy: Policies_data) {
        self.policy = policy
        _policyType = State(initialValue: policy.policy_type ?? "")
        _premiumAmount = State(initialValue: policy.premium_amount)
        _endDate = State(initialValue: policy.end_date ?? Date())
        _startDate = State(initialValue: policy.start_date ?? Date())
    }

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
                            formatter: numberFormatter()).keyboardType(.decimalPad)
                    }
                    Section() {
                        DatePicker(
                            "Start Date", selection: $startDate,
                            displayedComponents: .date).disabled(true)
                    }
                    Section() {
                        DatePicker(
                               "End Date", selection: $endDate,
                               displayedComponents: .date)
                    }
                    Section(header: Text("Customer ID")) {
                        Text("\(policy.customer_id)")
                    }
                }
                Button("Update") {
                    // Update the policy function
                    updatePolicy(policy: policy)
                }.buttonStyle(.bordered)

            }.navigationTitle("Policy Details")
             .alert(item: $errorMessage) { errorWrapper in
                            Alert(title: Text("Error"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK")))
                        }
        }
    }

    func updatePolicy(policy: Policies_data) {
        // Update the policy
        // Validate fields
                 guard !policyType.isEmpty else {
                            errorMessage = ErrorWrapper(message: "Policy Type cannot be empty")
                            return
                        }
                        guard premiumAmount > 0 else {
                            errorMessage = ErrorWrapper(message: "Premium Amount must be greater than zero")
                            return
                        }
                        guard endDate >= startDate else {
                            errorMessage = ErrorWrapper(message: "End Date cannot be before Start Date")
                            return
                        }
        // Save the context
        do {
            policy.policy_type = policyType
            policy.premium_amount = premiumAmount
            policy.end_date = endDate
            try policy.managedObjectContext?.save()
            //            go back to the previous view
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

struct PolicyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock managed object context
        let context = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType)

        // Initialize the Policies_data instance within the context
        let policy = Policies_data(context: context)
        policy.policy_type = "Health"
        policy.premium_amount = 100.0
        policy.start_date = Date()
        policy.end_date = Date()
        policy.customer_id = 12345

        return PolicyDetailView(policy: policy)
    }
}

#Preview {
    PolicyDetailView(policy: Policies_data())
}

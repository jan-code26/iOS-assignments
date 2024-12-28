//
//  PolicyDetailView.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/19/24.
//

import SwiftUI

struct PolicyDetailView: View {
    var policy: Policies_data
    var body: some View {
        NavigationView {
            VStack {
                
                Form {
                    Section(header: Text("Policy Type")) {
                        Text(policy.policy_type ?? "Unknown Policy")
                    }
                    Section(header: Text("Premium Amount")) {
                        Text("\(policy.premium_amount)")
                    }
                    Section(header: Text("Start Date")) {
                        Text("\(policy.start_date ?? Date(), style: .date)")
                    }
                    Section(header: Text("End Date")) {
                        Text("\(policy.end_date ?? Date(), style: .date)")
                    }
                    Section(header: Text("Customer ID")) {
                        Text("\(policy.customer_id)")
                    }
                }
                
            }.navigationTitle("Policy Details")
        }
    }
}

#Preview {
    PolicyDetailView(policy: Policies_data())
}

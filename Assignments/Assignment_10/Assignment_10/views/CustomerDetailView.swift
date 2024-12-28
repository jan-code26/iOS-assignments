//
//  CustomerDetailView.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/19/24.
//

import SwiftUI

struct CustomerDetailView: View {
    var customer: Customers_data

    var body: some View {
        NavigationView {
            VStack {

                Form {
                    Section(header: Text("Name")) {
                        Text(customer.name ?? "Unknown Name")
                    }
                    Section(header: Text("Age")) {
                        Text("\(customer.age)")
                    }
                    Section(header: Text("Email")) {
                        Text(customer.email ?? "Unknown Email")
                    }
                    Section(header: Text("Avatar")) {
                        HStack {
                            Spacer()
                            AsyncImage(url: URL(string: customer.avatar!)) {
                                phase in
                                switch phase {
                                case .failure:
                                    Image(systemName: "photo").font(.largeTitle)
                                case .success(let image):
                                    image.resizable()
                                default: ProgressView()
                                }
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            Spacer()
                        }
                    }
                }
            }.navigationTitle("Customer Details")
        }
         
    }

}

#Preview {
    CustomerDetailView(customer: Customers_data())
}

//
//  APIUtils.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/18/24.
//

import CoreData
import Network
import UIKit

class APIUtils: NSObject {
    static let apiKey: String = "16df6b70"

    // Function to check network reachability
    static func isNetworkReachable(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
            monitor.cancel()
        }
        monitor.start(queue: queue)
    }

    //MARK: customer
    static func getAllCustomerDetails(
        context: NSManagedObjectContext
    ) {
        isNetworkReachable { isReachable in
            guard isReachable else {
                print("No network connection")
                return
            }

            let session = URLSession(configuration: .default)
            guard
                let url = URL(
                    string:
                        "https://my.api.mockaroo.com/Customer.json?key=\(apiKey)"
                )
            else {
                print("Invalid URL, we can't update your feed")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(
                "application/json", forHTTPHeaderField: "Content-Type")

            let task = session.dataTask(with: request) {
                (data, response, error) in
                if error != nil {
                    print("Error fetching data")
                    return
                }

                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                else {
                    print("Error: invalid HTTP response code")
                    return
                }

                guard let data = data else {
                    print("Error: missing response data")
                    return
                }

                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.managedObjectContext] =
                    context

                do {
                    _ = try decoder.decode(

                        [Customers_data].self, from: data)
                    try context.save()

                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")

                }
            }
            task.resume()
        }
    }

    static func getAllInsuranceDetails(
        context: NSManagedObjectContext
    ) {
        isNetworkReachable { isReachable in
            guard isReachable else {
                print("No network connection")
                return
            }

            let session = URLSession(configuration: .default)
            guard
                let url = URL(
                    string:
                        "https://my.api.mockaroo.com/insurance.json?key=\(apiKey)"
                )
            else {
                print("Invalid URL, we can't update your feed")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(
                "application/json", forHTTPHeaderField: "Content-Type")

            let task = session.dataTask(with: request) {
                (data, response, error) in
                if error != nil {
                    print("Error fetching data: \(error!.localizedDescription)")
                    return
                }

                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                else {
                    print("Error: invalid HTTP response code")
                    return
                }

                guard let data = data else {
                    print("Error: missing response data")
                    return
                }

                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.managedObjectContext] =
                    context

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateStr = try container.decode(String.self)
                    if let date = ISO8601DateFormatter().date(from: dateStr) {
                        return date
                    } else if let date = dateFormatter.date(from: dateStr) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(
                            in: container,
                            debugDescription:
                                "Expected date string to be ISO8601-formatted or in MM/dd/yyyy format."
                        )
                    }
                }

                do {
                    _ = try decoder.decode(

                        [Policies_data].self, from: data)
                    try context.save()
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
    }

}

import Network
import CoreData
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
static func getAllCustomerDetails(context: NSManagedObjectContext, completion: @escaping ([Customer_table]) -> Void) {
    isNetworkReachable { isReachable in
        guard isReachable else {
            print("No network connection")
            return completion([])
        }

        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://my.api.mockaroo.com/Customer.json?key=\(apiKey)") else {
            print("Invalid URL, we can't update your feed")
            return completion([])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching data")
                return completion([])
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error: invalid HTTP response code")
                return completion([])
            }

            guard let data = data else {
                print("Error: missing response data")
                return completion([])
            }

            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context

            do {
                let customerDetails = try decoder.decode([Customer_table].self, from: data)
                completion(customerDetails)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
        }
        task.resume()
    }
}

static func getAllInsuranceDetails(context: NSManagedObjectContext, completion: @escaping ([Insurance_table]) -> Void) {
    isNetworkReachable { isReachable in
        guard isReachable else {
            print("No network connection")
            return completion([])
        }

        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://my.api.mockaroo.com/insurance.json?key=\(apiKey)") else {
            print("Invalid URL, we can't update your feed")
            return completion([])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching data: \(error!.localizedDescription)")
                return completion([])
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error: invalid HTTP response code")
                return completion([])
            }

            guard let data = data else {
                print("Error: missing response data")
                return completion([])
            }

            // Print raw JSON data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }

            let decoder = JSONDecoder()
                        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context

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
                                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected date string to be ISO8601-formatted or in MM/dd/yyyy format.")
                                }
                            }

            do {
                let insuranceDetails = try decoder.decode([Insurance_table].self, from: data)
                completion(insuranceDetails)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
        }
        task.resume()
    }
}
static func getAllClaimDetails(context: NSManagedObjectContext, completion: @escaping ([Claim_table]) -> Void) {
    isNetworkReachable { isReachable in
        guard isReachable else {
            print("No network connection")
            return completion([])
        }

        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://my.api.mockaroo.com/claims.json?key=\(apiKey)") else {
            print("Invalid URL, we can't update your feed")
            return completion([])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching data: \(error!.localizedDescription)")
                return completion([])
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error: invalid HTTP response code")
                return completion([])
            }

            guard let data = data else {
                print("Error: missing response data")
                return completion([])
            }

            // Print raw JSON data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }

            let decoder = JSONDecoder()
                        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context

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
                                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected date string to be ISO8601-formatted or in MM/dd/yyyy format.")
                                }
                            }

            do {
                let claimDetails = try decoder.decode([Claim_table].self, from: data)
                completion(claimDetails)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
        }
        task.resume()
    }
}

static func getAllPaymentDetails(context: NSManagedObjectContext, completion: @escaping ([Payment_table]) -> Void) {
    isNetworkReachable { isReachable in
        guard isReachable else {
            print("No network connection")
            return completion([])
        }

        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://my.api.mockaroo.com/payment.json?key=\(apiKey)") else {
            print("Invalid URL, we can't update your feed")
            return completion([])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching data: \(error!.localizedDescription)")
                return completion([])
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error: invalid HTTP response code")
                return completion([])
            }

            guard let data = data else {
                print("Error: missing response data")
                return completion([])
            }

            // Print raw JSON data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }

            let decoder = JSONDecoder()
                        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context

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
                                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected date string to be ISO8601-formatted or in MM/dd/yyyy format.")
                                }
                            }

            do {
                let paymentDetails = try decoder.decode([Payment_table].self, from: data)
                completion(paymentDetails)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
        }
        task.resume()
    }
}
}

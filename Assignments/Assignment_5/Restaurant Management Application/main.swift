//
//  main.swift
//  Restaurant Management Application
//
//  Created by jahnavi patel on 10/11/24.
//

import Foundation

// Menu Item Class
class MenuItem {
    var name: String // Name of the menu item
    var description: String // Description of the menu item
    var price: Double // Price of the menu item
    var category: String // Category of the menu item
    
    init(name: String, description: String, price: Double, category: String) {
        self.name = name
        self.description = description
        self.price = price
        self.category = category
    }
}

// Order Item Structure
struct orderItem {
    var item: MenuItem // Item in the order
    var quantity: Int // Quantity of the item
}

// Order Class
class Order {
    var orderID: Int // Order ID
    var customer: Customer // Customer placing the order
    var totalAmount: Double // Total price of all items in the order
    var status: String  // Status of the order
    var orderDate: Date // Date and time when the order was placed
    var items: [orderItem]  // List of menu items included in the order
    
    init(
        orderID: Int,
        customer: Customer,
        totalAmount: Double,
        status: String,
        orderDate: Date,
        items: [orderItem]
    ) {
        self.orderID = orderID
        self.customer = customer
        self.totalAmount = totalAmount
        self.status = status
        self.orderDate = orderDate
        self.items = items
    }
}



// Customer Class
class Customer {
    var customerID: Int // Customer ID
    var name: String    // Full name of the customer
    var email: String   // Email address of the customer
    var phoneNumber: String // Contact number
    
    init(customerID: Int, name: String, email: String, phoneNumber: String) {
        self.customerID = customerID
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
    }
}

// Restaurant Management System
class RestaurantManagementSystem {
    var menuItems: [MenuItem] = [] // List of menu items
    var orders: [Order] = [] // List of orders
    var customers: [Customer] = [] // List of customers
    
    // Function to add a new menu item
    func addMenuItem() {
        print("Enter the name of the menu item:")
        let name = readLine() ?? ""
        print("Enter the description of the menu item:")
        let description = readLine() ?? ""
        print("Enter the price of the menu item:")
        let price = Double(readLine() ?? "") ?? 0.0
        print("Enter the category of the menu item:")
        let category = readLine() ?? ""
        
        // Check if the menu item already exists
        if menuItems.contains(where: { $0.name == name }) {
            print("Menu item with the same name already exists.")
        } else if (
            name.isEmpty || description.isEmpty || price == 0.0 || category.isEmpty
        ) {
            print(
                "Please enter valid details."
            ) // if any of the fields are empty or price is zero
        } else {
            let menuItem = MenuItem(
                name: name,
                description: description,
                price: price,
                category: category
            )
            menuItems.append(menuItem)
            print("Menu item added successfully.")
        }
    }
    
    // Function to view all menu items
    func viewMenuItems() {
        let sortedMenuItems = menuItems.sorted { $0.category < $1.category }
        if sortedMenuItems.isEmpty{
            print("No menu items available.")
        }
        print("---------------")
        for menuItem in sortedMenuItems {
            print("Name: \(menuItem.name)")
            print("Description: \(menuItem.description)")
            print("Price: \(menuItem.price)")
            print("Category: \(menuItem.category)")
            print("---------------")
        }
    }
    
    // Function to modify details of a menu item
    func updateMenuItem() {
        print("Enter the name of the menu item to update:")
        let name = readLine() ?? ""
        if let index = menuItems.firstIndex(where: { $0.name == name }) {
            print("Enter the new name of the menu item:")
            let newName = readLine() ?? menuItems[index].name
            // Check if the new name already exists
            if !(newName==name) && menuItems
                .contains(where: { $0.name == newName }) {
                print("Menu item with the same name already exists.")
                return
            }
            print("Enter the new price of the menu item:")
            let price = Double(readLine() ?? "") ?? menuItems[index].price
            print("Enter the new description of the menu item:")
            let description = readLine() ?? menuItems[index].description
            print("Enter the new category of the menu item:")
            let category = readLine() ?? menuItems[index].category
            if price > 0 {
                menuItems[index].name = newName
                menuItems[index].price = price
                menuItems[index].description = description
                menuItems[index].category = category
                print("Menu item updated successfully.")
            } else {
                print("Price must be greater than zero.")
            }
        } else {
            print("Menu item not found.")
        }
    }
    
    //    function to add customer
    func addCustomer() {
        print("Enter the name of the customer:")
        let name = readLine() ?? ""
        print("Enter the email of the customer:")
        let email = readLine() ?? ""
        print("Enter the phone number of the customer:")
        let phoneNumber = readLine() ?? ""
        if customers.contains(where: { $0.email == email }) {
            print("Customer with the same email already exists.")
        } else if (name.isEmpty || email.isEmpty || phoneNumber.isEmpty) {
            print("Please enter valid details.")
        } else {
            let customerID = customers.count + 1
            let customer = Customer(
                customerID: customerID,
                name: name,
                email: email,
                phoneNumber: phoneNumber
            )
            customers.append(customer)
            print("Customer added successfully.")
        }
    }
    
    func viewCustomers() {
        let sortedCustomers = customers.sorted { $0.name < $1.name }
        if sortedCustomers.isEmpty{
            print("No customers found.")
        }
        print("---------------")
        for customer in sortedCustomers {
            print("Customer ID: \(customer.customerID)")
            print("Name: \(customer.name)")
            print("Email: \(customer.email)")
            print("Phone Number: \(customer.phoneNumber)")
            print("---------------")
        }
    }
    
    //Get date from user function
    func getDateFromUser() -> Date {
        let date = readLine() ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if let validDate = dateFormatter.date(from: date) {
            return validDate
        } else {
            print("Invalid date. Enter again")
            return getDateFromUser()
        }
    }
    
    //function to add order
    func addOrder() {
        print("Enter the customer ID:")
        let customerID = Int(readLine() ?? "") ?? 0
        if let customer = customers.first(
            where: { $0.customerID == customerID
            }) {
            print("Enter the number of items in the order:")
            let itemCount = Int(readLine() ?? "") ?? 0
            var items: [orderItem] = []
            var totalAmount = 0.0
            var orderDate=Date()
            while items.count < itemCount {
                print("Enter the name of the menu item:")
                let name = readLine() ?? ""
                if let menuItem = menuItems.first(where: { $0.name == name }) {
                    print("Enter the quantity:")
                    let quantity = Int(readLine() ?? "") ?? 0
                    let item = orderItem(item: menuItem, quantity: quantity)
                    items.append(item)
                    totalAmount += menuItem.price * Double(quantity)
                    print("Enter the order date(MM-dd-yyyy):")
                    orderDate = getDateFromUser()
                } else {
                    print("Menu item not found.")
                    print("continue or cancel?")
                    
                }
            }
            if !items.isEmpty{
                let orderID = orders.count + 1
                let order = Order(
                    orderID: orderID,
                    customer: customer,
                    totalAmount: totalAmount,
                    status: "Pending",
                    orderDate: orderDate,
                    items: items
                )
                orders.append(order)
                print("Order placed successfully.")
            }
            else{
                print("No items in order list")
            }
        } else {
            print("Customer not found.")
        }
    }
    
    // Function to view all orders
    func viewOrders() {
        let sortedOrders = orders.sorted { $0.orderDate > $1.orderDate }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if sortedOrders.isEmpty {
            print("No orders found.")
        }
        print("---------------")
        for order in sortedOrders {
            print("Order ID: \(order.orderID)")
            print("Customer: \(order.customer.name)")
            print("Total Amount: \(order.totalAmount)")
            print("Status: \(order.status)")
            let formattedDate = dateFormatter.string(from: order.orderDate)
            print("Order Date: \(formattedDate)")
            print("Items:")
            for item in order.items {
                print("Name: \(item.item.name), Quantity: \(item.quantity)")
            }
            print("---------------")
        }
    }
    
    //update order status with options given
    func updateOrder() {
        print("Enter the order ID:")
        let orderID = Int(readLine() ?? "") ?? 0
        if let order = orders.first(where: { $0.orderID == orderID }) {
            if order.status == "Delivered" {
                print("Order has already been delivered and cannot be updated.")
                return
            }
            print("Enter the new status:")
            print("1. Pending")
            print("2. In Progress")
            print("3. Ready")
            print("4. Delivered or Completed")
            let choice = Int(readLine() ?? "") ?? 0
            switch choice {
            case 1:
                order.status = "Pending"
                print("Order status updated successfully.")
            case 2:
                order.status = "In Progress"
                print("Order status updated successfully.")
            case 3:
                order.status = "Ready"
                print("Order status updated successfully.")
            case 4:
                order.status = "Delivered"
                print("Order status updated successfully.")
            default:
                print("Invalid choice.")
            }
        } else {
            print("Order not found.")
        }
    }
    
    // Function to cancel an order
    func cancelOrder() {
        print("Enter the order ID:")
        let orderID = Int(readLine() ?? "") ?? 0
        if let index = orders.firstIndex(where: { $0.orderID == orderID }) {
            if orders[index].status == "Delivered" {
                print(
                    "Order that has already been delivered cannot be canceled."
                )
            } else {
                orders.remove(at: index)
                print("Order canceled successfully.")
            }
        } else {
            print("Order not found.")
        }
    }
    
    // Function to remove a menu item
    func removeMenuItem() {
        print("Enter the name of the menu item to remove:")
        let name = readLine() ?? ""
        if let index = menuItems.firstIndex(where: { $0.name == name }) {
            if orders
                .contains(
                    where: { $0.items.contains(
                        where: { $0.item.name == name
                        }) && $0.status != "Delivered"
                    }) {
                print(
                    "Menu item that is part of an active order cannot be removed."
                )
            } else {
                menuItems.remove(at: index)
                print("Menu item removed successfully.")
            }
        } else {
            print("Menu item not found.")
        }
    }
    
    func updateCustomer() {
        print("Enter the customer ID:")
        let customerID = Int(readLine() ?? "") ?? 0
        if orders
            .contains(
                where: { $0.customer.customerID == customerID  && $0.status != "Delivered"
                }) {
            print("Customer has pending orders cannot be updated.")
        } else
        if let customer = customers.first(
            where: { $0.customerID == customerID
            }) {
            print("Enter the new name of the customer:")
            let name = readLine() ?? ""
            print("Enter the new email of the customer:")
            let email = readLine() ?? ""
            print("Enter the new phone number of the customer:")
            let phoneNumber = readLine() ?? ""
            if customers
                .contains(
                    where: { $0.email == email && $0.customerID != customerID
                    }) {
                print("Customer with the same email already exists.")
            } else if (name.isEmpty || email.isEmpty || phoneNumber.isEmpty) {
                print("Please enter valid details.")
            } else {
                customer.name = name
                customer.email = email
                customer.phoneNumber = phoneNumber
                print("Customer details updated successfully.")
            }
        } else {
            print("Customer not found.")
        }
    }
    
    // Function to remove a customer
    func removeCustomer() {
        print("Enter the customer ID:")
        let customerID = Int(readLine() ?? "") ?? 0
        if orders.contains(where: { $0.customer.customerID == customerID }) {
            print("Customer has active or past orders and cannot be removed.")
        } else if let index = customers.firstIndex(
            where: { $0.customerID == customerID
            }) {
            customers.remove(at: index)
            print("Customer removed successfully.")
        } else {
            print("Customer not found.")
        }
    }
}

// Main
let restaurant = RestaurantManagementSystem()
restaurant.menuItems
    .append(
        MenuItem(
            name: "Pizza",
            description: "Cheese Pizza",
            price: 10.0,
            category: "Main Course"
        )
    )
restaurant.menuItems
    .append(
        MenuItem(
            name: "Burger",
            description: "Veg Burger",
            price: 5.0,
            category: "Main Course"
        )
    )
restaurant.menuItems
    .append(
        MenuItem(
            name: "Coke",
            description: "Cold Drink",
            price: 2.0,
            category: "Beverage"
        )
    )

restaurant.customers
    .append(
        Customer(
            customerID: 1,
            name: "John Doe",
            email: "John@mail.com",
            phoneNumber: "1234567890"
        )
    )
restaurant.customers
    .append(
        Customer(
            customerID: 2,
            name: "Jane Doe",
            email: "Jane@mail.com",
            phoneNumber: "9876543210"
        )
    )

restaurant.orders
    .append(
        Order(
            orderID: 1,
            customer: restaurant.customers[0],
            totalAmount: 15.0,
            status: "Delivered",
            orderDate: Date(),
            items: [
                orderItem(item: restaurant.menuItems[0], quantity: 1),
                orderItem(item: restaurant.menuItems[2], quantity: 2)
            ]
        )
    )
restaurant.orders
    .append(
        Order(
            orderID: 2,
            customer: restaurant.customers[1],
            totalAmount: 10.0,
            status: "Pending",
            orderDate: Date(),
            items: [orderItem(item: restaurant.menuItems[1], quantity: 2)]
        )
    )

var choice = 0
repeat {
    print("Restaurant Management System")
    print("1. Add Menu Item")
    print("2. View Menu Items")
    print("3. Update Menu Item")
    print("4. Add Customer")
    print("5. View Customers")
    print("6. Add Order")
    print("7. View Orders")
    print("8. Update Order Status")
    print("9. Delete Order")
    print("10. Delete Menu Item")
    print("11. Update Customer")
    print("12. Remove Customer")
    print("15: Exit")
    print("Enter your choice:")
    choice = Int(readLine() ?? "") ?? 0
    switch choice {
    case 1:
        restaurant.addMenuItem()
    case 2:
        restaurant.viewMenuItems()
    case 3:
        restaurant.updateMenuItem()
    case 4:
        restaurant.addCustomer()
    case 5:
        restaurant.viewCustomers()
    case 6:
        restaurant.addOrder()
    case 7:
        restaurant.viewOrders()
    case 8:
        restaurant.updateOrder()
    case 9:
        restaurant.cancelOrder()
    case 10:
        restaurant.removeMenuItem()
    case 11:
        restaurant.updateCustomer()
    case 12:
        restaurant.removeCustomer()
    case 15:
        print("Exiting the program.")
    default:
        print("Invalid choice. Please try again.")
    }
} while choice != 15


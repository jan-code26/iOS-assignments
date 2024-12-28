//
//  main.swift
//  Assignment_4
//
//  Created by jahnavi patel on 10/6/24.
//

import Foundation


//INFO 6350 Fall 2024
//Assignment 4
//Use Swift playground and/or the command line for macOS (open
//XCode, create a new XCode project, macOS, command line tool), and
//practice the following exercises:
//Swift Structures:
//1. Define a Swift structure named Animal with four properties: name
//(String), type (String), age (Int), and location (String). Example: (“Leo”,
//“Lion”, 5, “Lion Den”)

struct Animal {
    var name: String
    var type: String
    var age: Int
    var location: String
    
    //2. Add a method called showDetails() to the Animal structure that returns a
    //description of the animal, including its type and location.
    func showDetails() -> String {
        return "\(name) is a \(type) of age \(age) and is located at \(location)"
    }
}
//3. Create three instances of the Animal structure with different values for
//name, type, age, and location. Provide details for each instance.

// Create first instance of Animal
var animal1 = Animal(
    name: "Leo",
    type: "Lion",
    age: 5,
    location: "Lion Den"
)

// Create second instance of Animal
var animal2 = Animal(
    name: "Tweety",
    type: "Bird",
    age: 3,
    location: "Bird Cage"
)

// Create third instance of Animal
var animal3 = Animal(
    name: "Rex",
    type: "Dog",
    age: 7,
    location: "Home"
)

//4. Choose one instance of the Animal structure and call the showDetails()
//method. Display the output in the console.

print(
    animal2.showDetails()
)

//Swift Class:
//1. Define a class Cage with two methods: spaceLeft() and animalsInside().

class Cage {
    
    // Method to calculate space left
    func spaceLeft() {}
    
    // Method to calculate number of animals inside
    func animalsInside() {}
}

//2. Create a subclass LionCage inheriting from Cage, with properties
//totalSpace and lionsCount. Override the methods to calculate the space
//left and the number of lions inside.

class LionCage: Cage {
    var totalSpace: Int = 100
    var lionsCount: Int = 10
    
    // Method to calculate space left
    override func spaceLeft() {
        print("Space Left: \(totalSpace - lionsCount)")
    }
    
    // Method to calculate number of lions inside
    override func animalsInside() {
        print("Number of Lions: \(lionsCount)")
    }
}

//3. Define another subclass BirdCage inheriting from Cage, with properties
//birdCount and maxBirds. Override the methods to calculate space left
//and the number of birds inside.

class BirdCage: Cage {
    var birdCount: Int = 20
    var maxBirds: Int = 50
    
    // Method to calculate space left
    override func spaceLeft() {
        print("Space Left: \(maxBirds - birdCount)")
    }
    
    // Method to calculate number of birds inside
    override func animalsInside() {
        print("Number of Birds: \(birdCount)")
    }
}

//4. Create an instance of LionCage with totalSpace and lionsCount and an
//instance of BirdCage with birdCount and maxBirds.

var lionCage = LionCage()
var birdCage = BirdCage()

lionCage.totalSpace = 100
lionCage.lionsCount = 10

birdCage.birdCount = 20
birdCage.maxBirds = 50

//5. Print the space left and the number of animals in the LionCage using a
//method called showCageInfo().

func showCageInfo(cage: Cage) {
    cage.spaceLeft()
    cage.animalsInside()
}

print(
    "\nLion Cage Info:"
)
showCageInfo(
    cage: lionCage
)

//6. Similarly, print the space left and the number of birds in the BirdCage
//using showCageInfo().
print(
    "\nBird Cage Info:"
)
showCageInfo(
    cage: birdCage
)

//Swift Protocols:
//1. Define a protocol Move with a method moveToCage(). Create a
//ZooTruck and ZooTrain struct that conform to it and implement the
//moveToCage() method.

protocol Move {
    func moveToCage()
}

struct ZooTruck: Move {
    func moveToCage() {
        print(
            "Zoo Truck is moving to the cage."
        )
    }
}

struct ZooTrain: Move {
    func moveToCage() {
        print(
            "Zoo Train is moving to the cage."
        )
    }
}

var zooTruck = ZooTruck()
var zooTrain = ZooTrain()

print("\nZoo Vehicles:")
zooTruck.moveToCage()
zooTrain.moveToCage()

//2. Create a protocol ZooArea that has:

protocol ZooArea {
    //a. A method to return the name of the area (e.g., "Lion Den", "Parrot
    //House").
    func areaName() -> String
    
    //b. A method that calculates and returns the total space of the area.
    func totalSpace() -> Int
}
//c. Define two classes that conform to this protocol, such as LionDen
//and ParrotHouse.

class LionDen: ZooArea {
    func areaName() -> String {
        return "Lion Den"
    }
    
    func totalSpace() -> Int {
        return 100
    }
}

class ParrotHouse: ZooArea {
    func areaName() -> String {
        return "Parrot House"
    }
    
    func totalSpace() -> Int {
        return 50
    }
}

var lionDen = LionDen()
var parrotHouse = ParrotHouse()

print("\nLion Den:")
print("Area Name: \(lionDen.areaName())")
print("Total Space: \(lionDen.totalSpace())")

print("\nParrot House:")
print("Area Name: \(parrotHouse.areaName())")
print("Total Space: \(parrotHouse.totalSpace())")

//Swift Extensions:
//1. Extend the Int type to include a method named ticketPrice() that
//calculates and returns the ticket price in dollars by multiplying the integer
//by 10. Use this method to print the ticket prices for Adult, Children, and
//Senior Citizen categories.
extension Int {
     func ticketPrice() -> Int {
        return self * 10
    }
}

print("\nTicket Prices:")
print("Adult: \(20.ticketPrice()) dollars")
print("Children: \(10.ticketPrice()) dollars")
print("Senior Citizen: \(15.ticketPrice()) dollars")


//2. Extend String to add a method animalType() that converts the string into
//an animal's type (e.g., "elephant", "giraffe"). Print the corresponding
//animal types.

extension String {
    func animalType() -> String {
        switch self.lowercased() {
        case "lion":
            return "Big Cat"
        case "parrot":
            return "Bird"
        case "elephant":
            return "Pachyderm"
        case "giraffe":
            return "Ungulate"
        default:
            return "Unknown Animal Type"
        }
    }
}

// Usage
print("\nAnimal Types:")
var animalType = "lion".animalType()
print("lion is a \(animalType)") // Outputs: Big Cat

animalType = "parrot".animalType()
print("parrot is a \(animalType)") // Outputs: Bird

animalType = "elephant".animalType()
print("elephant is a \(animalType)") // Outputs: Pachyderm

//3. Extend Date to add a method visitDate() that returns a formatted string
//like "Visit on: MMM dd, yyyy". Print formatted visit dates.


extension Date {
    func visitDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return "Visit on: " + formatter.string(from: self)
    }
}

print("\nDate:")
let date = Date()
print(date.visitDate())

//Swift Error Handling and Optionals in Ticket Price Calculation:
//1. Create an enumeration AgeError that defines two possible errors:
//invalidInput and negativeAge.

enum AgeError: Error {
    case invalidInput
    case negativeAge
}

//2. Write a method calculateTicketPrice(for:) that accepts an optional
//integer age. Use optional binding (guard let or if let) to unwrap the age.
//3. If the age is invalid or negative, throw the appropriate error from the
//AgeError enumeration.

func calculateTicketPrice(for age: Int?) throws -> Int {
    guard let age = age else {
        throw AgeError.invalidInput
    }
    
    guard age >= 0 else {
        throw AgeError.negativeAge
    }
    
    return age
}


//  4. Use a switch statement to return the appropriate ticket price based on the
//customer's age:
//a. Ages 0-12: $10 (Children)
//b. Ages 13-59: $20 (Adults)
//c. Ages 60+: $15 (Senior Citizens)

func ticketPrice(for age: Int) -> Int {
    switch age {
    case 0...12:
        return 10
    case 13...59:
        return 20
    default:
        return 15
    }
}

//5. Implement a do-catch block to call the calculateTicketPrice() method,
//handle errors, and print the appropriate ticket price. Handle these cases:
//d. invalidInput: Print "Please enter a valid age."
//e. negativeAge: Print "Age cannot be negative."

do {
    let ticketPrice = try calculateTicketPrice(for: 25)
    print("Ticket Price: \(ticketPrice) dollars")
} catch AgeError.invalidInput {
    print("Please enter a valid age.")
} catch AgeError.negativeAge {
    print("Age cannot be negative.")
} catch {
    print("An unknown error occurred.")
}

//6. Create test cases to simulate valid and invalid inputs (e.g., "25", "-5",
 //"abc").

 func testCalculateTicketPrice(for age: Int?) {
     do {
         let ticketPrice = try calculateTicketPrice(for: age)
         print("Ticket Price: \(ticketPrice) dollars")
     } catch AgeError.invalidInput {
         print("Please enter a valid age.")
     } catch AgeError.negativeAge {
         print("Age cannot be negative.")
     } catch {
         print("An unknown error occurred.")
     }
 }
 
 print("\nTest Cases:")
 testCalculateTicketPrice(for: 25) // Valid input
 testCalculateTicketPrice(for: -5) // Negative age
 testCalculateTicketPrice(for: nil) // Invalid input
 testCalculateTicketPrice(for: Int("abc")) // Invalid input


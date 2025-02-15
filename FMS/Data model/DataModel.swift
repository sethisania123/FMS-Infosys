//
//  DataModel.swift
//  FMS
//
//  Created by Soham Chakraborty on 12/02/25.
//

import FirebaseFirestore
import Foundation

enum Role: String, Codable {
    case fleet = "Fleet Manager"
    case driver = "Driver"
    case maintenance = "Maintenance Personnel"
}

enum Experience: String, Codable, CaseIterable {
    case lessThanOne = "Less than 1 year"
    case lessThanFive = "Less than 5 years"
    case moreThanFive = "More than 5 years"
    func getPriority() -> Int {
        switch self {
        case .lessThanOne:
            return 3
        case .lessThanFive:
            return 2
        case .moreThanFive:
            return 1
        }
    }
}

enum GeoPreference: String, Codable, CaseIterable {
    case hilly = "Hilly Areas"
    case plain = "Plain Areas"
}

enum VehicleType: String, Codable, CaseIterable {
    case truck = "Truck"
    case van = "Van"
    case car = "Car"
}

enum FuelType: String, Codable {
    case petrol = "Petrol"
    case diesel = "Diesel"
    case hybrid = "Hybrid"
    case electric = "Electric"
}

enum TripStatus: String, Codable {
    case scheduled = "Scheduled"
    case inprogress = "In Progress"
    case completed = "Completed"
}

class User: Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var email: String
    var phone: String
    var role: Role
//    var dateCreated: Date = Date()
    
    init(name: String, email: String, phone: String, role: Role) {
        self.name = name
        self.email = email
        self.phone = phone
        self.role = role
    }
}

class Driver: User, Identifiable {
    var experience: Experience
    var license: String
    var geoPreference: GeoPreference
    var vehiclePreference: VehicleType
    var status: Bool

    init(name: String, email: String, phone: String, experience: Experience, license: String, geoPreference: GeoPreference, vehiclePreference: VehicleType, status: Bool) {
        self.experience = experience
        self.license = license
        self.geoPreference = geoPreference
        self.vehiclePreference = vehiclePreference
        self.status = status
        super.init(name: name, email: email, phone: phone, role: .driver)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class Vehicle: Codable {
    @DocumentID var id: String? = UUID().uuidString
    var type: VehicleType
    var model: String
    var registrationNumber: String
    var fuelType: FuelType
    var mileage: Float
    var rc: String
    var vehicleImage: String
    var insurance: String
    var pollution: String
    
    init(type: VehicleType, model: String, registrationNumber: String, fuelType: FuelType, mileage: Float, rc: String, vehicleImage: String, insurance: String, pollution: String) {
        self.type = type
        self.model = model
        self.registrationNumber = registrationNumber
        self.fuelType = fuelType
        self.mileage = mileage
        self.rc = rc
        self.vehicleImage = vehicleImage
        self.insurance = insurance
        self.pollution = pollution
    }
}

class Trip: Codable {
    @DocumentID var id: String? = UUID().uuidString
    var tripDate: Date
    var startLocation: String
    var endLocation: String
    var distance: Float
    var estimatedTime: Float
    var assignedDriver: Driver?
    var TripStatus: TripStatus
    
    init(tripDate: Date, startLocation: String, endLocation: String, distance: Float, estimatedTime: Float, assignedDriver: Driver?, TripStatus: TripStatus) {
        self.tripDate = tripDate
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.distance = distance
        self.estimatedTime = estimatedTime
        self.assignedDriver = assignedDriver
        self.TripStatus = TripStatus
    }
}

/*class FirebaseService {
    private let db = Firestore.firestore()
    
    func addUser(_ user: User, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("users").document(user.id!).setData(from: user, completion: completion)
        } catch let error {
            completion(error)
        }
    }
    
    func addVehicle(_ vehicle: Vehicle, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("vehicles").document(vehicle.id!).setData(from: vehicle, completion: completion)
        } catch let error {
            completion(error)
        }
    }
}
*/

//
//  FireStoreService.swift
//  FMS
//
//  Created by Aastik Mehta on 14/02/25.
//

//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//class FirestoreService {
//    private let db = Firestore.firestore()
//    
//    // Function to add a new trip
//    func addTrip(trip: Trip, completion: @escaping (Result<Void, Error>) -> Void) {
//        do {
//            let tripRef = db.collection("trips").document(trip.id ?? UUID().uuidString)
//            try tripRef.setData(from: trip) { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(()))
//                }
//            }
//        } catch {
//            completion(.failure(error))
//        }
//    }
//}

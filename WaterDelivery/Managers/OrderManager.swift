//
//  UserOrderManager.swift
//  WaterDelivery
//
//  Created by Emil on 18.01.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class OrderManager {
    
    //  Create a singleton class for Order Manager and give it a name 'OrderManager'. This class will manage all the operations related to the order.
    static let shared = OrderManager()
    
    //  Create an array to store the order objects and initialize it with an empty array. You will use this array to store all the orders that you get from the Firebase database.
    var orders = [Order]()
    
    //  Initialize the FirebaseFirestore library so that you can perform all the operations related to Firebase. You can create an instance of Firestore and store it in a constant/variable.
    let db = Firestore.firestore()

    //  Define a save method that takes an Order object as an argument. This method will be used to save the Order object in Firebase. You can use the setData method of the Firestore library to save the Order object in the Firebase database.
    func save(order: Order, completion: @escaping () -> Void) {
        do {
            try db.collection("Orders").document("\(order.orderId)").setData(from: order)
            completion()
        } catch let error {
            print("\(error)")
        }
    }
    
    //  Define a loadOrderData method that takes an id as an argument. This method will be used to load the order details from the Firebase database by using the id. You can use the getDocument method of the Firestore library to retrieve the Order object from Firebase.
    func loadOrderData(by id: String, completion: @escaping (Order) -> Void) {
        
        let docRef = db.collection("Orders").document(id)
        docRef.getDocument(as: Order.self) { result in
            switch result {
            case .success(let order):
                print("Order: \(order)")
                completion(order)
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    //  Define a loadAllData method that takes an id as an argument. This method will be used to load all the orders for a specific user from Firebase. You can use the whereField method and the getDocuments method of the Firestore library to retrieve all the Order objects from Firebase.
    func loadAllData(by id: String, completion: @escaping ()-> Void) {
        let docRef = db.collection("Orders").whereField("userId", isEqualTo: id)
        docRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let snapShotDocuments = querySnapshot?.documents {
                    for document in snapShotDocuments {
                        do {
                            let model = try document.data(as: Order.self)
                            self.orders.append(model)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            self.orders.sort { order, order1 in
                (order.createdDate ?? Date()) > (order1.createdDate ?? Date())
            }
            completion()
        }
    }
}

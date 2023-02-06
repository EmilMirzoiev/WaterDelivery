//
//  Firestore+User.swift
//  WaterDelivery
//
//  Created by Emil on 14.12.22.
//

import Foundation
//Importing required libraries:
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager {
    
    //  Initialize the FirebaseFirestore library so that you can perform all the operations related to Firebase. You can create an instance of Firestore and store it in a constant/variable.
    let db = Firestore.firestore()
    
    //  Create a function called saveUserFields that takes in a user object and uses the Firestore SDK to save the user to the database.
    func saveUserFields(user: User) {
        do {
            try db.collection("Users").document(user.uid).setData(from: user)
        } catch let error {
            print("\(error)")
        }
    }
    
    //  Create a function called loadUserData that takes in a user ID and a completion handler. This function uses the Firestore SDK to retrieve the user data from the database and return it in the completion handler.
    func loadUserData(by id: String, completion: @escaping (User) -> Void) {
        let docRef = db.collection("Users").document(id)
        
        docRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                print("User: \(user)")
                completion(user)
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    //  Create a function called checkIfUserExist that uses the Firestore SDK to check if user exist or not in the database and return a boolean value in the completion handler.
    func checkIfUserExist(id: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("Users").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }    
}

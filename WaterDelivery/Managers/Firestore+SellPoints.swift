//
//  Firestore + SellPoints.swift
//  WaterDelivery
//
//  Created by Emil on 16.01.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SellPointsManager {

    //  Create a variable models to hold an array of SellPoint objects
    var models: [SellPoint] = []
    
    //  Create a variable db to hold an instance of Firestore from the FirebaseFirestore framework.
    let db = Firestore.firestore()
    
    //  Create a method getModelthat takes in a GeoPoint coordinate and returns the first sell point in the models array whose geopoint is equal to the input coordinate.
    func getModel(by coordinate: GeoPoint) -> SellPoint? {
        let first = models.first { sellPoint in
            sellPoint.geopoint == coordinate
        }
        return first
    }
    
    //  Create a method getSellPoints(completion: @escaping () -> Void) that retrieves all the sell points from the Firestore database.
    //  In this method, you first use the getDocuments method on the db.collection("SellPoints") to retrieve the sell points from the Firestore database. If there is an error, you print out the error description. If there is no error, you get the snapshotDocuments from the querySnapshot and iterate through the documents. In each iteration, you try to decode the document data into a SellPoint object using the document.data(as: SellPoint.self) method.
    //  If the decoding is successful, you append the resulting SellPoint object to the models array. If there is an error during the decoding, you print out the error. Finally, you dispatch to the main queue and call the completion closure to signal that the data retrieval is complete.
    func getSellPoints(completion: @escaping () -> Void) {
        db.collection("SellPoints").getDocuments { querySnapshot, error in
            if let error = error {
                print (error.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        do {
                            let model = try document.data(as: SellPoint.self)
                            self.models.append(model)
                        }
                        catch {
                            print(error)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}

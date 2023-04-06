//
//  Firestore+Products.swift
//  WaterDelivery
//
//  Created by Emil on 15.12.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class ProductManager {
    
    //  Create an array to store the product objects and initialize it with an empty array. You will use this array to store all the products that you get from the Firebase database and then to send it to the ProductsVC via completion.
    var products = [Product]()
    
    //  Initialize the FirebaseFirestore library so that you can perform all the operations related to Firebase. You can create an instance of Firestore and store it in a constant/variable.
    let db = Firestore.firestore()
    
    //  Create a function called loadProductData which takes in an id string and a completion handler. The function uses Firestore to get the document from the "Products" collection with the specified id. The document is then decoded as a Product object, and passed to the completion handler.
    func loadProductData(by id: String, completion: @escaping (Product) -> Void) {
        let docRef = db.collection("Products").document(id)
        
        docRef.getDocument(as: Product.self) { result in
            switch result {
            case .success(let product):
                print("Product: \(product)")
                completion(product)
            case .failure(let error):
                print("Error decoding products: \(error)")
            }
        }
    }
    
    //  The "loadProductData" method uses a "ProductManager" object to retrieve a collection of documents from the Firebase database. Each document represents a product, and the method uses a "Product" struct to parse the data in each document into a new "Product" object. These products are then added to an array of products, which is used as the data source for the collection view.
    func loadProductData(completion: @escaping ([Product]) -> Void) {
        db.collection("Products").getDocuments { (querySnapshot, error) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        do {
                            let product = try document.data(as: Product.self)
                                self.products.append(product)
                        } catch {
                            print(error)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(self.products)
                }
            }
        }
    }
    
}

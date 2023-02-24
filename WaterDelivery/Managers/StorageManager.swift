//
//  StorageManager.swift
//  WaterDelivery
//
//  Created by Emil on 10.01.23.
//

import Foundation
import FirebaseStorage

class StorageManager {
    
    //  Create a function called uploadAvatarData that takes in a user ID, image data, and a completion handler. This function uses the Firebase Storage SDK to upload the avatar data to the database.
    func uploadAvatarData(userUid: String, imageData: Data, completion: @escaping () -> Void) {
        Storage.storage().reference().child("avatars").child("\(userUid)").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            completion()
        }
    }
    
    func uploadDefaultAvatarURL(completion: @escaping (URL?) -> Void) {
        let productRef = Storage.storage().reference().child("avatars").child("defaultAvatar.jpg")
        productRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else {
                completion(url)
            }
        }
    }
    
    //  Create another function called getDownloadURL that takes in a folder name, user ID, and a completion handler. This function uses the Firebase Storage SDK to retrieve the download URL from the database and return it in the completion handler.
    func getDownloadURL(folder: String, userUid: String, completion: @escaping (String) -> Void) {
        //get download url
        Storage.storage().reference().child(folder).child(userUid).downloadURL { url, error in
            guard let url = url, error == nil else {
                return
            }
            let urlString = url.absoluteString
            completion(urlString)
        }
    }
    
    // Create a method to fetch the product image from Firebase Storage and return it as a URL.
    func fetchProductImageURL(folderName: String, uid: String, completion: @escaping (URL?) -> Void) {
        let productRef = Storage.storage().reference().child(folderName).child("\(uid).png")
        productRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else {
                completion(url)
            }
        }
    }
}

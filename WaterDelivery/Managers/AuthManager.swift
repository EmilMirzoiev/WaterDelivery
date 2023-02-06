//
//  AuthManager.swift
//  WaterDelivery
//
//  Created by Emil on 01.01.23.
//

import Foundation
import FirebaseAuth

//  Create a new Swift file called AuthManager.swift and create a singleton class called AuthManager.
class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private var verificationId: String?
    
    //  Create a function called startAuth that takes in a phoneNumber and a completion handler.
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        //  Use the Firebase Auth SDK to start a phone number verification process with the provided phone number.
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            //  If the process fails, call the completion handler with false.
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                return
            }
            //  If the process is successful, store the returned verificationId and call the completion handler with true.
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    //  Create a function called verifyCode that takes in an smsCode and a completion handler
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        //  Use the Firebase Auth SDK to verify the code and sign in the user.
        //  If the code is not verified or the user is not successfully signed in, call the completion handler with false
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        //  If the code is verified and the user is successfully signed in, call the completion handler with true.
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        completion(true)
        
        //  This code is a Swift code block for signing in a user using the Firebase Authentication API. The function auth.signIn(with: credential) takes in a credential argument and performs the sign-in action. The completion block takes two arguments, result and error. If the result is not nil and the error is nil, it means the sign-in was successful and the completion block is called with completion(true). If either result is nil or error is not nil, it means the sign-in was not successful and the completion block is called with completion(false).
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}

